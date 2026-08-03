// Centrální registr externích Typst balíčků.
// Při aktualizaci verzí měňte primárně tento soubor.

#import "@preview/ez-today:2.1.0" as ez-today

// Lokální náhrada balíčku @preview/vlna — viz src/styling/vlna.typ
// (navíc: dvoupísmenná slova, tituly před/za jménem, zkratky).
#import "@preview/vlna:0.3.0": apply-vlna

#import "@preview/codly:1.3.0": codly, codly-init
#import "@preview/codly-languages:0.1.10": codly-languages

#import "@preview/drafting:0.2.2": (
  absolute-place, inline-note, margin-note, note-outline, rule-grid, set-margin-note-defaults,
  set-page-properties,
)

#import "@preview/pyrunner:0.3.0" as py
