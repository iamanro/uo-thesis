// Běžné („živé") záhlaví. Zapíná se parametrem `fancy_heading: true`.
//
// Stav `body-started` se nastaví na `true` těsně před tělem práce
// (viz render-final-layout), takže se záhlaví nikdy neobjeví na titulní straně,
// v úvodních částech ani v seznamech. Na první straně kapitoly se potlačí
// (na ní je vysázen samotný název kapitoly). Pro oboustranný tisk je zarovnané
// k vnějšímu okraji (liché strany vpravo, sudé vlevo); při `twoside: false`
// vždy vpravo.
#let body-started = state("unob-body-started", false)

#let running-header(fancy_heading: false, lang: "cs", twoside: true) = {
  if fancy_heading != true {
    none
  } else {
    context {
      let started = body-started.at(here()) == true
      // Pozor: `before(here())` nadpis na TÉTO straně nevidí (záhlaví je
      // v pořadí dokumentu před obsahem strany) — poslední nález by byla
      // předchozí kapitola a potlačení na první straně kapitoly by selhalo.
      // Proto se filtruje podle čísla strany přes všechny H1. Bere se poslední
      // H1 bez ohledu na číslování: nečíslovaný (ZÁVĚR, BIBLIOGRAFIE, seznamy)
      // záhlaví umlčí — jinak by zadní část nesla název poslední kapitoly.
      let h1s = query(heading.where(level: 1)).filter(h => (
        h.location().page() <= here().page()
      ))
      if started and h1s.len() > 0 {
        let ch = h1s.last()
        // Na straně, kde kapitola začíná, se záhlaví nesází.
        if ch.numbering != none and ch.location().page() != here().page() {
          let num = numbering(ch.numbering, ..counter(heading).at(ch.location()))
          let outer = if not twoside { right } else if calc.odd(here().page()) { right } else { left }
          block(width: 100%, {
            set text(size: 9pt)
            set par(justify: false, first-line-indent: 0pt)
            set align(outer)
            [#num~#ch.body]
            v(2pt)
            line(length: 100%, stroke: 0.5pt)
          })
        }
      }
    }
  }
}
