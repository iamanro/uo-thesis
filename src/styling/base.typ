#import "packages.typ": apply-vlna, codly, codly-init, codly-languages
#import "helpers.typ": centered-page-footer
#import "running-header.typ": running-header
#import "../config.typ": cfg

/// Nastaví globální sazbu dokumentu (text, stránka, rovnice, odkazy).
#let apply-base-styles(
  body,
  draft: false,
  lang: "cs",
  author: (),
  thesis: (),
  abstract: (),
  keywords: (),
  theme: (),
  vlna: true,
  fancy_heading: false,
  twoside: true,
) = {
  // Určení barvy odkazů: priorita — vlastní > fakultní > černá
  let links_on = theme.at("links_colored", default: false)
  let faculty_on = theme.at("faculty_colored", default: false)
  let link_color = if not links_on {
    cfg.link.mono-color
  } else if theme.at("link_color", default: none) != none {
    theme.at("link_color")
  } else if faculty_on and theme.at("faculty_color", default: none) != none {
    theme.at("faculty_color")
  } else {
    cfg.link.mono-color
  }
  show link: set text(fill: link_color)

  show: codly-init.with()
  codly(languages: codly-languages)

  show: if vlna != false { apply-vlna } else { it => it }
  if draft != true {
    // Pravidlo: Při `draft: false` přidá kompenzaci proti vdovám a sirotkům.
    show par: it => {
      let threshold = 10%
      block(breakable: false, height: threshold)
      v(-threshold, weak: true)
      it
    }
  }

  // Klíčová slova do metadat PDF: česká, pak anglická (prázdné vynechá).
  let combined_keywords = (keywords.czech, keywords.english)
    .filter(k => type(k) == str and k.trim() != "")
    .map(str.trim)
    .join(", ", default: "")

  set document(
    author: (author.prefix, author.name, author.surname, author.suffix).filter(part => part not in (none, "")).join(" "),
    title: thesis.title,
    date: auto,
    description: abstract.czech,
    keywords: combined_keywords,
  )

  set text(
    lang: lang,
    bottom-edge: "bounds",
    size: cfg.text.size,
    overhang: true,
    font: cfg.text.font,
    fallback: true,
    hyphenate: true,
    costs: if draft != true {
      (runt: 1000%, hyphenation: 1000%, widow: 1000%, orphan: 1000%)
    } else {
      (runt: 100%, hyphenation: 100%, widow: 100%, orphan: 100%)
    },
  )

  show math.equation: set text(font: cfg.text.math-font, fallback: true)
  show raw: set text(font: cfg.text.raw-font, fallback: true)

  set page(
    margin: if draft == true {
      (
        left: cfg.page.draft.left, right: cfg.page.draft.right,
        top: cfg.page.draft.top, bottom: cfg.page.draft.bottom,
      )
    } else if twoside {
      (inside: cfg.page.margin-inside, outside: cfg.page.margin-outside, y: cfg.page.margin-y)
    } else {
      // Jednostranný režim: pevný hřbetní okraj vlevo (žádné střídání parity).
      (left: cfg.page.margin-inside, right: cfg.page.margin-outside, y: cfg.page.margin-y)
    },
    header: if draft != true and fancy_heading == true {
      running-header(fancy_heading: true, lang: lang, twoside: twoside)
    } else {
      none
    },
    header-ascent: 40%,
    // Vlastní patička číslo skutečně vykresluje; `numbering` jen určuje vzor,
    // který si `centered-page-footer()` přečte z `page.numbering`.
    numbering: "1",
    footer: centered-page-footer(),
    paper: cfg.page.paper,
    binding: auto,
  )

  set par(
    first-line-indent: (amount: cfg.par.indent, all: false),
    linebreaks: if draft != true { "optimized" } else { "simple" },
    leading: cfg.par.leading,
    justify: true,
    justification-limits: (
      spacing: (
        min: cfg.par.spacing-min, // default: 66.67%
        max: cfg.par.spacing-max,
      ),
    ),
  )

  set enum(indent: cfg.par.list-indent, spacing: cfg.par.enum-spacing)
  set list(indent: cfg.par.list-indent, spacing: cfg.par.list-spacing)

  set footnote.entry(indent: 0em)

  set math.equation(numbering: (..nums) => {
    // Před první číslovanou kapitolou je čítač 0 — vynutíme alespoň 1.
    let safe_section = calc.max(counter(heading).get().first(), 1)
    numbering("(1.1)", safe_section, ..nums)
  })

  body
}
