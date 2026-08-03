#import "../pages/internal/i18n/index.typ": t
#import "helpers.typ": (
  centered-page-footer, frontmatter-heading, reset-section-counters, subheading-rule,
  upper-keep-raw,
)
#import "../config.typ": cfg

// Formát číslování stránek a figur v přílohách (A–1, A–2, ...).
#let appendix-num-fmt = "A\u{2013}1"

// Odstraní z obsahu poznámky pod čarou (footnote) — používá se pro názvy příloh
// v seznamu, kde by se poznámka z nadpisu jinak vysázela na patu strany.
#let strip-footnotes(body) = {
  if body.has("children") {
    body.children.filter(c => c.func() != footnote).map(strip-footnotes).join()
  } else if body.func() == footnote {
    none
  } else {
    body
  }
}

#let appendix-heading-number(it) = if it.numbering != none {
  numbering(it.numbering, ..counter(heading).at(it.location()))
} else {
  none
}

#let appendix-page-number(n) = numbering(
  appendix-num-fmt,
  calc.max(counter(heading).get().first(), 1),
  n,
)

// Funkce: render-appendix-list-title
// Účel: Vykreslí seznam příloh jako H1, aby byl v hlavním obsahu i PDF záložkách.
#let render-appendix-list-title(lang: "cs") = {
  frontmatter-heading(t("list_appendices", lang: lang), bookmarked: true, outlined: true)
}

#let has-appendix-headings(lang: "cs") = {
  query(heading.where(level: 1, supplement: t("appendix", lang: lang))).len() > 0
}

// Funkce: apply-appendix-outline-styles
// Účel: Vykreslí seznam příloh bez zapojení přílohových nadpisů do hlavního obsahu.
// Vzhled: tučná značka „PŘÍLOHA A" + název normální vahou; bez tečkového vodiče
// a bez čísel stran; víceřádkové názvy mají zavěšené odsazení.
#let apply-appendix-outline-styles(lang: "cs") = context {
  let appendix_label = t("appendix", lang: lang)
  let entries = query(heading.where(level: 1, supplement: appendix_label))

  // Poznámky pod čarou v názvech příloh se v seznamu nesázejí (patří do těla);
  // odstraníme je přímo z obsahu názvu (viz `strip-footnotes`), protože `show
  // footnote: none` potlačí jen značku, ale text poznámky by se stejně vysázel.
  set par(justify: false, first-line-indent: 0pt)

  for entry in entries {
    // Vlastní titul „SEZNAM PŘÍLOH" je také H1 s tímtéž supplementem, ale nemá
    // číslování (numbering: none) — do seznamu příloh nepatří, přeskočíme jej.
    if entry.numbering == none { continue }

    let loc = entry.location()
    let letter = calc.max(counter(heading).at(loc).first(), 1)

    block(width: 100%, above: 0.75em, below: 0.75em, grid(
      columns: (auto, 1fr),
      column-gutter: 0.8em,
      align: (left + top, left + top),
      strong[#appendix_label~#numbering("A", letter)],
      strip-footnotes(entry.body),
    ))
  }
}

// Funkce: apply-appendix-content-styles
// Účel: Nastaví číslování, nadpisy, čítače a figurální pravidla pro přílohy.
#let apply-appendix-content-styles(body, lang: "cs", twoside: true) = {
  show heading.where(level: 1): set heading(
    numbering: "A",
    supplement: t("appendix", lang: lang),
    outlined: false,
    bookmarked: true,
  )

  show heading.where(level: 1): it => {
    if twoside {
      // Příloha vždy začíná na lichém (pravém) listu — kvůli oboustrannému
      // tisku. Vložený vakát (dorovnání parity) je bez patičky, aby na
      // prázdné straně nebylo číslo stránky.
      {
        set page(footer: none)
        pagebreak(to: "odd")
      }
    } else {
      // Jednostranný režim: příloha začíná na nové straně, bez vakátů.
      pagebreak(weak: true)
    }
    counter(page).update(1)
    block(width: 100%)[
      #set text(size: cfg.heading.h1, weight: "bold")
      #set par(first-line-indent: 0mm)
      // Vlastní titul „SEZNAM PŘÍLOH" (bez čísla) se sází bez prefixu „PŘÍLOHA".
      #if it.numbering != none [#it.supplement #{ appendix-heading-number(it) } ]
      #upper-keep-raw(it.body)
      // Stejná mezera H1 → text jako v hlavní stati (viz headings.typ).
      #v(cfg.heading.h1-gap)
      #reset-section-counters()
    ]
  }

  // Tvrdé zalomení PŘED přepnutím sazby: `set page` se v Typstu aplikuje ještě
  // na rozepsanou stranu, takže bez něj by poslední strana předchozí části
  // (BIBLIOGRAFIE, resp. SEZNAM PŘÍLOH) přišla o číslo — potlačí ho `footer:
  // none` z vakátového bloku v H1 pravidle výše.
  pagebreak()

  set page(
    numbering: appendix-page-number,
    footer: centered-page-footer(),
  )

  // Čítač stránek nuluje až H1 každé přílohy (A–1, B–1, …); další reset tady
  // by jen přečísloval vakát mezi seznamem příloh a první přílohou.
  counter(heading).update(0)
  set heading(numbering: "A.1.1", outlined: false, bookmarked: true)

  set figure(numbering: appendix-page-number)

  for kind in (image, table, math.equation, raw) {
    show figure.where(kind: kind): set figure(outlined: false)
  }

  show heading.where(level: 2): set heading(outlined: false, bookmarked: true)
  show heading.where(level: 3): set heading(outlined: false, bookmarked: true)
  show heading.where(level: 4): set heading(numbering: none, outlined: false, bookmarked: true)
  show heading.where(level: 5): set heading(numbering: none, outlined: false, bookmarked: true)
  show heading.where(level: 2): subheading-rule(cfg.heading.h2, cfg.heading.h1-gap, cfg.heading.sub-gap)
  show heading.where(level: 3): subheading-rule(cfg.heading.h3, cfg.heading.h1-gap, cfg.heading.sub-gap)
  show heading.where(level: 4): subheading-rule(cfg.heading.h4, cfg.heading.h1-gap, cfg.heading.sub-gap)
  show heading.where(level: 5): subheading-rule(cfg.heading.h4, cfg.heading.h1-gap, cfg.heading.sub-gap)


  body
}
