"""Distribution checks: tag safety, archive contents, and reproducibility."""
import importlib.util
from pathlib import Path
import subprocess
import tarfile
import tempfile
import unittest

SPEC = importlib.util.spec_from_file_location("thesis_ci", Path(__file__).resolve().parents[1] / "scripts/ci.py")
CI = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(CI)


class ReleaseBundle(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        files = {
            "typst.toml": '[package]\nname = "example"\nversion = "1.2.3"\nentrypoint = "src/lib.typ"\n'
                          '[template]\npath = "template"\nentrypoint = "main.typ"\nthumbnail = "thumbnail.png"\n',
            "src/lib.typ": '#let title = "Thesis"\n',
            "template/main.typ": '#import "@local/example:1.2.3": title\n#title\n',
            "template/fonts/LICENSE-FONTS.txt": "Font attribution\n",
            "LICENSE": "Package license\n", "LICENSE-MIT-0": "Template license\n",
            "NOTICE": "Asset attribution\n",
            "thumbnail.png": "fixture", "README.md": "Instructions\n",
            "scripts/private.py": "must not ship", "AGENTS.md": "local instructions",
        }
        for name, contents in files.items():
            path = self.root / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(contents)
        subprocess.run(["git", "init", "-q", str(self.root)], check=True)
        subprocess.run(["git", "add", "."], cwd=self.root, check=True)
        # Even a generated file inside a distributable directory must not leak.
        (self.root / "template/private.pdf").write_text("untracked local draft")
        self.output = self.root / "dist"
        self.output.mkdir()

    def test_mismatched_tag_cannot_create_a_release_bundle(self):
        with self.assertRaisesRegex(ValueError, "must equal v1.2.3"):
            CI.package_bundle(self.root, self.output, 0, "v9.9.9")
        self.assertEqual(list(self.output.iterdir()), [])

    def test_archive_contains_only_tracked_distribution_files_and_is_reproducible(self):
        archive, _ = CI.package_bundle(self.root, self.output, 1700000000, "v1.2.3")
        with tarfile.open(archive) as bundle:
            self.assertEqual(set(bundle.getnames()), {
                "typst.toml", "src/lib.typ", "template/main.typ",
                "template/fonts/LICENSE-FONTS.txt", "LICENSE", "LICENSE-MIT-0", "NOTICE",
                "thumbnail.png", "README.md",
            })
            self.assertEqual(bundle.extractfile("src/lib.typ").read(), b'#let title = "Thesis"\n')
        again = self.root / "again"
        again.mkdir()
        (self.root / "src/lib.typ").touch()  # Filesystem timestamps are not release inputs.
        second, _ = CI.package_bundle(self.root, again, 1700000000, "v1.2.3")
        self.assertEqual(archive.read_bytes(), second.read_bytes())

    def test_missing_template_entrypoint_blocks_packaging(self):
        (self.root / "template/main.typ").unlink()
        with self.assertRaisesRegex(ValueError, "Missing or unsafe package file"):
            CI.package_bundle(self.root, self.output, 0)

    def test_symlinks_cannot_smuggle_external_files_into_the_package(self):
        (self.root / "src/lib.typ").unlink()
        (self.root / "src/lib.typ").symlink_to(self.root / "scripts/private.py")
        with self.assertRaisesRegex(ValueError, "regular file"):
            CI.package_bundle(self.root, self.output, 0)


class Snapshots(unittest.TestCase):
    def test_word_order_on_a_page_is_ignored_but_changed_words_are_reported(self):
        same = CI.snapshot_difference(["a b c", "d e"], ["c a b", "e d"])
        self.assertIsNone(same)
        changed = CI.snapshot_difference(["a b c", "d e"], ["a b c", "d x"])
        self.assertIn("strana 2", changed)
        self.assertIn("'e'", changed)
        self.assertIn("'x'", changed)

    def test_different_page_count_is_reported(self):
        self.assertIn("počet stran 1 → 2", CI.snapshot_difference(["a"], ["a", "b"]))


if __name__ == "__main__":
    unittest.main()
