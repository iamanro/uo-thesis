#import "i18n/index.typ": current-lang, t

// API: Helpery pro zadání frontmatter přímo v `main.typ`.
// Jak: Každý helper vloží neviditelný metadata uzel; hlavní template ho načte přes `query`.
#let acknowledgement(content) = [#metadata(content) <unob-fm-acknowledgement>]
#let introduction(content) = [#metadata(content) <unob-fm-introduction>]
#let abstract-cs(content) = [#metadata(content) <unob-fm-abstract-cs>]
#let abstract-en(content) = [#metadata(content) <unob-fm-abstract-en>]
#let keywords-cs(value) = [#metadata(value) <unob-fm-keywords-cs>]
#let keywords-en(value) = [#metadata(value) <unob-fm-keywords-en>]

// Funkce: conclusion
// Co: Vloží lokalizovaný nadpis závěru a obsah kapitoly.
#let conclusion(content) = context [
  #heading(level: 1, outlined: true, numbering: none)[#t("conclusion", lang: current-lang())]
  #content
]
