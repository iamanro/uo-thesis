#import "helpers.typ": reset-section-counters, subheading-rule
#import "../config.typ": cfg

/// Nastaví číslování, vzhled a zalamování nadpisů.
#let apply-heading-styles(body, draft: false, twoside: true) = {
  // Patička je nastavená globálně v base.typ; číslo se tiskne od strany, kterou
  // určí stav `page-numbering-from` (viz helpers.typ).
  set heading(numbering: "1.1.1", depth: 3)

  show heading.where(level: 1): it => {
    if draft != true {
      if twoside {
        // Kapitola vždy začíná na lichém (pravém) listu — kvůli oboustrannému
        // tisku. Vložený vakát (dorovnání parity) je bez patičky, aby na
        // prázdné straně nebylo číslo stránky.
        {
          set page(footer: none)
          pagebreak(to: "odd")
        }
      } else {
        // Jednostranný režim: kapitola začíná na nové straně, bez vakátů.
        pagebreak(weak: true)
      }
    }

    reset-section-counters()

    block(width: 100%)[
      #set text(size: cfg.heading.h1, weight: "bold")
      #set par(first-line-indent: 0mm)
      // Pozn.: `upper(it)` zvelčí i inline kód v nadpisu (`let x = 1` →
      // `LET X = 1`). Opravit to jde jen rozdělením na číslo + tělo
      // (jako v příloze, viz upper-keep-raw), ale výchozí typst rendering
      // nadpisu se pak nepodaří napodobit pixelově přesně (odzkoušeno:
      // obyčejná mezera i h(0.3em, weak: true) mění sazbu). Kód v nadpisu
      // je natolik vzácný, že to nestojí za změnu sazby všech nadpisů.
      #upper(it)
      #v(cfg.heading.h1-gap)
    ]
  }

  // Úrovně 2–4 se liší velikostí textu; mezeru NAD podnadpisem řídí stejné
  // pravidlo jako mezeru pod H1 (cfg.heading.h1-gap), mezeru POD podnadpisem
  // pak cfg.heading.sub-gap.
  show heading.where(level: 2): subheading-rule(cfg.heading.h2, cfg.heading.h1-gap, cfg.heading.sub-gap)
  show heading.where(level: 3): subheading-rule(cfg.heading.h3, cfg.heading.h1-gap, cfg.heading.sub-gap)
  show heading.where(level: 4): subheading-rule(cfg.heading.h4, cfg.heading.h1-gap, cfg.heading.sub-gap)
  // H4 zůstává číslovaný, aby na něj šlo odkazovat přes #ref (typst neumí
  // referencovat nečíslovaný nadpis). Reálná disertace to využívá: 24 nadpisů
  // H4 s labelem, na které odkazují popisky tabulek.
  show heading.where(level: 4): set heading(numbering: "1.1")
  show heading.where(level: 5): set heading(numbering: none)


  body
}
