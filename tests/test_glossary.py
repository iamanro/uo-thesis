"""Exercise glossary references through the public thesis interface.

Run: python3 -m unittest discover -s tests -v
Requires Typst and pdftotext; TYPST may point to a specific compiler binary.
"""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
TYPST = os.environ.get("TYPST", "typst")
DATA = '''(
  ApiKey: (short: "API", en: "Application interface", plural: "APIs"),
  alias: (short: "ApiKey", en: "Alias expansion"),
  process: (short: "Risk process", glossary: "A process definition."),
)'''


class GlossaryReferences(unittest.TestCase):
    def setUp(self):
        self.work = tempfile.TemporaryDirectory(dir=ROOT / "tests")
        self.addCleanup(self.work.cleanup)
        self.source = Path(self.work.name) / "main.typ"
        self.pdf = self.source.with_suffix(".pdf")
        self.flags = ["--root", str(ROOT), "--font-path", str(ROOT / "template/fonts"),
                      "--ignore-system-fonts"]

    def document(self, body, data=DATA, lists=False, draft=False, terms="data"):
        enabled = str(lists).lower()
        self.source.write_text('''#import "../../src/lib.typ": *
#let data = ''' + data + '''
#show: unob-thesis.with(
  lang: "en", faculty: "fvt", draft: ''' + str(draft).lower() + ''',
  twoside: false, vlna: false, declaration: false,
  assignment_front: false, assignment_back: false,
  acronyms: data, terms: ''' + terms + ''',
  outlines: (headings: false, figures: false, tables: false,
             acronyms: ''' + enabled + ''', terms: ''' + enabled + '''),
)
BEGINPROBE
''' + body + '''
ENDPROBE
''')
        return subprocess.run([TYPST, "compile", *self.flags, str(self.source), str(self.pdf)],
                              capture_output=True, text=True)

    def body_text(self, result):
        self.assertEqual(result.returncode, 0, result.stderr)
        text = subprocess.run(["pdftotext", str(self.pdf), "-"],
                              capture_output=True, text=True, check=True).stdout
        return " ".join(text.split("BEGINPROBE", 1)[1].split("ENDPROBE", 1)[0].split())

    def test_key_precedence_case_insensitivity_short_names_and_display(self):
        result = self.document('#trm("ApiKey") / #trm("apikey") / #trm("api") / '
                               '#trm("API", style: plural) / #trm("RISK PROCESS") / '
                               '#trm("process", display: [custom wording])')
        self.assertEqual(self.body_text(result),
                         "API / API / API / APIs / Risk process / custom wording")

    def test_links_follow_available_lists(self):
        for lists, draft in ((False, False), (True, False), (True, True)):
            with self.subTest(lists=lists, draft=draft):
                result = self.document('#trm("api") / #trm("risk process")', lists=lists, draft=draft)
                self.assertEqual(self.body_text(result), "API / Risk process")
                query = subprocess.run([TYPST, "query", *self.flags, str(self.source), "link", "--field", "dest"],
                                       capture_output=True, text=True, check=True)
                destinations = json.loads(query.stdout)
                expected = ["<__unob_acronym_list_ApiKey>", "<__unob_term_list_process>"] if lists and not draft else []
                self.assertEqual(destinations, expected)

    def test_unknown_reference_reports_candidates(self):
        result = self.document('#trm("ris")')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Unknown", result.stderr)
        self.assertIn("Risk process", result.stderr)

    def test_case_collisions_remain_errors(self):
        data = '(API: (short: "A", en: "First"), api: (short: "B", en: "Second"))'
        result = self.document('#trm("API")', data=data)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("key collision", result.stderr)

    def test_short_name_collisions_remain_errors(self):
        data = '(one: (short: "API", en: "First"), two: (short: "api", en: "Second"))'
        result = self.document('#trm("api")', data=data)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Duplicate `short`", result.stderr)

    def test_multi_word_short_is_still_an_acronym(self):
        data = '(mocr: (short: "MO ČR", cs: "Ministerstvo obrany České republiky"))'
        result = self.document('#trm("mocr") / #trm("mo čr")', data=data)
        self.assertEqual(self.body_text(result), "MO ČR / MO ČR")

    def test_different_glossaries_for_acronyms_and_terms_are_rejected(self):
        result = self.document('#trm("api")', terms='(other: (short: "X", glossary: "Y"))')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("same glossary", result.stderr)

    def test_empty_glossary_reports_unknown_reference(self):
        result = self.document('#trm("missing")', data="(:)")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("list is empty", result.stderr)


if __name__ == "__main__":
    unittest.main()
