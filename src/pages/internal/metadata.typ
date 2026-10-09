#import "i18n/index.typ": current-lang, t

// Funkce: conclusion
// Co: Vloží lokalizovaný nadpis závěru a obsah kapitoly.
#let conclusion(content) = context [
  #heading(level: 1, outlined: true, numbering: none)[#t("conclusion", lang: current-lang())]
  #content
]
