#import "@local/unob-thesis:0.1.0": * 

// ============================================================
// Tento soubor běžně NEUPRAVUJETE.
//   • Nastavení práce  →  config.toml
//   • Text práce       →  front/ a chapters/
// Novou kapitolu přidáte řádkem #include níže. Výjimečné změny
// (např. sken zadání) patří do .with(...) ZA spread — přepíšou
// hodnotu z config.toml.
// ============================================================
#let glossary = toml("glossary.toml")

#show: unob-thesis.with(
  ..thesis-config(toml("config.toml")),
  acronyms: glossary,
  terms: glossary,
  symbols: glossary,
  bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),
  appendix: [#include "appendix.typ"],
  // Zadání práce: sken či export — png, jpg/jpeg i pdf (vždy s alt textem, PDF/UA):
  // assignment_front: image("zadani-lic.pdf", alt: "Zadání práce — líc"),
  // assignment_back:  image("zadani-rub.jpg", alt: "Zadání práce — rub"),
)

// Úvodní části — texty jsou v front/ a chapters/.
#acknowledgement[#include "front/acknowledgement.typ"]
#abstract-cs[#include "front/abstract-cs.typ"]
#abstract-en[#include "front/abstract-en.typ"]
#introduction[#include "chapters/00-introduction.typ"]

// Kapitoly — každá ve svém souboru.
#include "chapters/01-theory.typ"
#include "chapters/02-objectives.typ"
#include "chapters/03-methodology.typ"
#include "chapters/04-results.typ"

#conclusion[#include "chapters/99-conclusion.typ"]
