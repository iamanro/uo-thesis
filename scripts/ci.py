#!/usr/bin/env python3
"""Validate and build the actual distributable template; Python 3.12+ only."""
import argparse
from collections import Counter
import difflib
import gzip
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tarfile
import tempfile
import tomllib

ROOT = Path(__file__).resolve().parents[1]
PACKAGE_PATHS = ("src", "template", "typst.toml", "README.md", "README.en.md", "CHANGELOG.md",
                 "LICENSE", "LICENSE-MIT-0", "NOTICE", "thumbnail.png")
PROFILES = {
    "template": {},
    "cs-electronic": {"lang": "cs", "faculty": "fvt", "draft": False,
                      "twoside": False, "fancy_heading": True},
    "en-print": {"lang": "en", "faculty": "vlf", "draft": False,
                 "twoside": True, "fancy_heading": True},
    "cs-draft": {"lang": "cs", "faculty": "uo", "draft": True},
    "en-draft": {"lang": "en", "faculty": "uo-fvl", "draft": True},
    "cs-uo-fvt": {"lang": "cs", "faculty": "uo-fvt", "draft": False},
    "en-uo-vlf": {"lang": "en", "faculty": "uo-vlf", "draft": False},
}


EXAMPLE = ROOT / "examples" / "diplomka"
SNAPSHOTS = ROOT / "tests" / "snapshots"
# Profily, jejichž text a počet stran hlídají snapshoty (PDF/A a PDF/UA mají text shodný s `template`).
SNAPSHOT_PROFILES = (*PROFILES, "ukazka-diplomka")


def page_texts(pdf):
    """Text jednotlivých stran PDF; datum a rok (závisí na času sestavení) se nahradí zástupcem."""
    text = subprocess.run(["pdftotext", str(pdf), "-"], check=True, text=True,
                          capture_output=True).stdout
    pages = []
    for page in text.split("\f")[:-1] if text.endswith("\f") else text.split("\f"):
        page = " ".join(page.split())
        page = re.sub(r"(dne )\d{1,2}\. \d{1,2}\. \d{4}", r"\1<datum>", page)
        page = re.sub(r"(BRNO|HRADEC KRÁLOVÉ) \d{4}", r"\1 <rok>", page)
        pages.append(page)
    return pages


def snapshot_difference(expected, actual):
    """Popis rozdílu mezi dvěma seznamy textů stran, nebo None. Pořadí slov na straně se
    nesrovnává (různé verze Poppleru řadí matematiku různě), srovnává se množina slov."""
    if len(expected) != len(actual):
        return f"počet stran {len(expected)} → {len(actual)}"
    for number, (old, new) in enumerate(zip(expected, actual), start=1):
        before, after = Counter(old.split()), Counter(new.split())
        if before != after:
            removed = sorted((before - after).elements())[:12]
            added = sorted((after - before).elements())[:12]
            return f"strana {number}: ubylo {removed}, přibylo {added}"
    return None


def check_snapshot(name, pdf):
    """Porovná text PDF se snapshotem v tests/snapshots; UPDATE_SNAPSHOTS=1 jej přepíše."""
    pages = page_texts(pdf)
    path = SNAPSHOTS / f"{name}.txt"
    if os.environ.get("UPDATE_SNAPSHOTS"):
        SNAPSHOTS.mkdir(exist_ok=True)
        path.write_text("\n\f\n".join(pages) + "\n")
        return
    if not path.is_file():
        raise ValueError(f"Chybí snapshot {path.relative_to(ROOT)}; vytvoř ho přes UPDATE_SNAPSHOTS=1")
    expected = path.read_text().rstrip("\n").split("\n\f\n")
    difference = snapshot_difference(expected, pages)
    if difference:
        raise ValueError(f"Sazba profilu {name} se změnila ({difference}). Je-li změna záměrná, "
                         f"spusť s UPDATE_SNAPSHOTS=1 a snapshot zkontroluj v diffu.")


def run(command, **kwargs):
    return subprocess.run(command, check=True, text=True, **kwargs)


def metadata(root, tag=""):
    with (root / "typst.toml").open("rb") as stream:
        data = tomllib.load(stream)
    package, template = data["package"], data["template"]
    if tag and tag != "v" + package["version"]:
        raise ValueError(f"Release tag {tag!r} must equal v{package['version']}")
    for relative in (package["entrypoint"],
                     str(Path(template["path"]) / template["entrypoint"]),
                     template["thumbnail"], "LICENSE", "LICENSE-MIT-0", "NOTICE"):
        path = root / relative
        if not path.resolve().is_relative_to(root.resolve()) or not path.is_file():
            raise ValueError(f"Missing or unsafe package file: {relative}")
    return data


def package_bundle(root, output, epoch, tag=""):
    data = metadata(root, tag)
    package = data["package"]
    # Tracked allowlisted files only: never ship PDFs, caches, or local agent files.
    tracked = run(["git", "ls-files", "-z", "--", *PACKAGE_PATHS],
                  cwd=root, capture_output=True).stdout.split("\0")
    files = sorted(name for name in tracked if name)
    archive = output / f"{package['name']}-{package['version']}.tar.gz"
    with archive.open("xb") as raw:
        with gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=epoch) as compressed:
            with tarfile.open(fileobj=compressed, mode="w") as bundle:
                for name in files:
                    path = root / name
                    if path.is_symlink() or not path.is_file():
                        raise ValueError(f"Package member must be a regular file: {name}")
                    info = bundle.gettarinfo(str(path), arcname=name)
                    info.uid = info.gid = 0
                    info.uname = info.gname = ""
                    info.mtime = epoch
                    info.mode = 0o644
                    with path.open("rb") as stream:
                        bundle.addfile(info, stream)
    return archive, data


def configure(path, overrides):
    # Only change root-level values in the generated project's existing config.
    # Leave its tables, comments, and actual template entrypoint intact.
    header, separator, tables = path.read_text().partition("\n[")
    for key, value in overrides.items():
        header, count = re.subn(rf"(?m)^{re.escape(key)}\s*=.*$",
                                f"{key} = {json.dumps(value, ensure_ascii=False)}", header)
        if count != 1:
            raise ValueError(f"Expected one root-level {key!r} in {path}")
    path.write_text(header + separator + tables)


def check(output, tag=""):
    data = metadata(ROOT, tag)
    compiler = os.environ.get("TYPST", "typst")
    version = run([compiler, "--version"], capture_output=True).stdout.strip()
    if version.split()[1] != data["package"]["compiler"]:
        raise ValueError(f"Use Typst {data['package']['compiler']}; found {version}")
    run([sys.executable, "-m", "unittest", "discover", "-s", "tests", "-v"], cwd=ROOT)
    if output.exists() and any(output.iterdir()):
        raise ValueError(f"Output directory must be empty: {output}")
    output.mkdir(parents=True, exist_ok=True)
    epoch = int(os.environ.get("SOURCE_DATE_EPOCH") or
                run(["git", "log", "-1", "--format=%ct"], cwd=ROOT, capture_output=True).stdout)
    archive, data = package_bundle(ROOT, output, epoch, tag)
    package, template = data["package"], data["template"]
    builds = []
    with tempfile.TemporaryDirectory(prefix="unob-ci-") as temporary:
        work = Path(temporary)
        packages = work / "packages"
        installed = packages / "local" / package["name"] / package["version"]
        installed.mkdir(parents=True)
        with tarfile.open(archive) as bundle:
            bundle.extractall(installed, filter="data")
        project = work / "project"
        run([compiler, "init", "--package-path", str(packages),
             f"@local/{package['name']}:{package['version']}", str(project)])
        original_config = (project / "config.toml").read_bytes()
        cases = [(name, overrides, None) for name, overrides in PROFILES.items()]
        cases += [("pdf-a-3b", {}, "a-3b"), ("pdf-ua-1", {}, "ua-1")]
        for name, overrides, standard in cases:
            (project / "config.toml").write_bytes(original_config)
            configure(project / "config.toml", overrides)
            pdf = output / f"{name}.pdf"
            command = [compiler, "compile", "--root", str(work),
                       "--package-path", str(packages), "--font-path", str(project / "fonts"),
                       "--ignore-system-fonts", "--creation-timestamp", str(epoch),
                       "--jobs", "2", "--diagnostic-format", "short"]
            if standard:
                command += ["--pdf-standard", standard]
            command += [str(project / template["entrypoint"]), str(pdf)]
            result = run(command, capture_output=True)
            if result.stderr:
                print(result.stderr, file=sys.stderr)
            if "warning:" in result.stderr:
                raise ValueError(f"Typst warnings in {name}; fix references/layout before shipping")
            if name in SNAPSHOT_PROFILES:
                check_snapshot(name, pdf)
            info = run(["pdfinfo", str(pdf)], capture_output=True).stdout
            pages = int(re.search(r"(?m)^Pages:\s+(\d+)", info)[1])
            builds.append({"profile": name, "overrides": overrides, "standard": standard,
                           "pages": pages, "bytes": pdf.stat().st_size})
            print(f"{name}: {pages} pages ({pdf.stat().st_size} bytes)", flush=True)
    # Ukázková práce se sází ze zdrojů v repozitáři (nejde do balíčku); PDF/UA zde nelze,
    # protože vyžaduje `alt` u každé rovnice, proto PDF/A-3b.
    for name, standard in (("ukazka-diplomka", None), ("ukazka-diplomka-pdfa", "a-3b")):
        pdf = output / f"{name}.pdf"
        command = [compiler, "compile", "--root", str(ROOT), "--font-path", str(ROOT / "template" / "fonts"),
                   "--ignore-system-fonts", "--creation-timestamp", str(epoch), "--jobs", "2",
                   "--diagnostic-format", "short"]
        if standard:
            command += ["--pdf-standard", standard]
        command += [str(EXAMPLE / "main.typ"), str(pdf)]
        result = run(command, capture_output=True)
        if result.stderr:
            print(result.stderr, file=sys.stderr)
        if "warning:" in result.stderr:
            raise ValueError(f"Typst warnings in {name}")
        if name in SNAPSHOT_PROFILES:
            check_snapshot(name, pdf)
        info = run(["pdfinfo", str(pdf)], capture_output=True).stdout
        pages = int(re.search(r"(?m)^Pages:\s+(\d+)", info)[1])
        builds.append({"profile": name, "overrides": {}, "standard": standard,
                       "pages": pages, "bytes": pdf.stat().st_size})
        print(f"{name}: {pages} pages ({pdf.stat().st_size} bytes)", flush=True)
    manifest = {"compiler": version, "package": package["name"], "version": package["version"],
                "commit": run(["git", "rev-parse", "HEAD"], cwd=ROOT, capture_output=True).stdout.strip(),
                "source_date_epoch": epoch, "builds": builds}
    (output / "build-info.json").write_text(json.dumps(manifest, indent=2) + "\n")
    checksums = [f"{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.name}\n"
                 for path in sorted(output.iterdir()) if path.is_file()]
    (output / "SHA256SUMS").write_text("".join(checksums))
    print(f"Validated release artifacts: {output}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["check"])
    parser.add_argument("--output", type=Path, default=Path("dist"))
    parser.add_argument("--tag", default="", help="Require an exact v<package.version> release tag")
    args = parser.parse_args()
    try:
        check(args.output.resolve(), args.tag)
    except (ValueError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        if isinstance(error, subprocess.CalledProcessError) and error.stderr:
            print(error.stderr, file=sys.stderr)
        sys.exit(1)
