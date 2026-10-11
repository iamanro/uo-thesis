// Ukázková (fiktivní) diplomová práce na šabloně unob-thesis.
// Kompilace z kořene repozitáře:
//   typst compile --root . --font-path template/fonts examples/diplomka/main.typ
//
// V reálné práci se import níže nahradí `#import "@local/unob-thesis:0.1.0": *`
// (nebo `@preview/…`, až bude šablona v Typst Universe); zde míří na zdrojové
// soubory v repozitáři, aby ukázka šla sázet bez instalace balíčku.
#import "../../src/lib.typ": *
#import "@preview/zero:0.7.1": set-num, set-group

#let glossary = toml("glossary.toml")

#show: unob-thesis.with(
  ..thesis-config(toml("config.toml")),
  acronyms: glossary, terms: glossary, symbols: glossary,
  bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),
  acknowledgement: include "front/acknowledgement.typ",
  abstract: (
    czech: include "front/abstract-cs.typ",
    english: include "front/abstract-en.typ",
  ),
  introduction: include "chapters/00-introduction.typ",
  // Sken zadání: zde jednoduchá grafika s popisem `alt` (PDF/UA, submit_check).
  assignment_front: image("assets/zadani-lic.svg", alt: "Zadání práce, líc (ukázkový sken)"),
  assignment_back: image("assets/zadani-rub.svg", alt: "Zadání práce, rub (ukázkový sken)"),
  appendix: [#include "appendix.typ"],
)

// Česká sazba čísel: desetinná čárka a mezera mezi tisíci (balíček zero).
#set-num(decimal-separator: ",")
#set-group(separator: sym.space.thin, threshold: 5)

#include "chapters/01-theory.typ"
#include "chapters/02-objectives.typ"
#include "chapters/03-methodology.typ"
#include "chapters/04-results.typ"

#conclusion[#include "chapters/99-conclusion.typ"]
