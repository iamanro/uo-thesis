#import "../config.typ": cfg

/// Nastaví vzhled popisků a číslování obrázků, tabulek a rovnic.
/// `accent`: barva fakulty pro záhlaví tabulek (`none` = neutrální šedá, např. při `theme.color = false`).
#let apply-figure-styles(body, accent: none) = {
  set figure(numbering: n => numbering(
    "1.1",
    // Před první číslovanou kapitolou je čítač 0 — vynutíme alespoň 1.
    calc.max(counter(heading).get().first(), 1),
    n,
  ))

  // Pozn.: `show` uvnitř `for` smyčky platí jen pro (prázdný) zbytek dané
  // iterace, takže se nikdy neprojeví mimo smyčku — proto tři pravidla zvlášť.
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: math.equation): set figure.caption(position: top)

  // Dlouhé tabulky se zalamují přes strany; `table.header` v obsahu se pak
  // automaticky opakuje na každé další straně. (Obal `block(breakable: true)`
  // níže nestačí — zalomitelný musí být vlastní blok figury.)
  show figure.where(kind: table): set block(breakable: true)

  // Knižní styl (booktabs): bez svislých čar a mřížky; silnější linka nahoře
  // a dole (kreslí ji obalový blok), tenká linka pod hlavičkou. Hlavička má
  // jemné podbarvení (barva fakulty, jinak šedá) a těla tabulky střídavé pruhy
  // pro čitelnost dlouhých řádků; v černobílém tisku zůstává jen světlý odstín.
  let header-fill = if accent == none { luma(92%) } else { accent.lighten(80%) }
  let zebra-fill = if accent == none { luma(97%) } else { accent.lighten(94%) }
  set table(
    stroke: (_, y) => if y == 0 { (bottom: cfg.table.rule-inner) },
    fill: (_, y) => if y == 0 { header-fill } else if calc.even(y) { zebra-fill },
    inset: (x: cfg.table.inset-x, y: cfg.table.inset-y),
  )
  set table.hline(stroke: cfg.table.rule-inner)
  show table: it => block(
    stroke: (top: cfg.table.rule-outer, bottom: cfg.table.rule-outer),
    // Odsazení o tloušťku linky: podbarvení buněk nesmí zakrýt vnější linky.
    inset: (y: cfg.table.rule-outer),
    breakable: true,
    it,
  )
  show table.cell.where(y: 0): strong
  show table: set text(size: cfg.table.size, hyphenate: false)
  show table: set par(justify: false, first-line-indent: 0mm)

  // Oddělovač popisku skládáme ručně (nezlomitelná mezera `~` mezi číslem a
  // názvem), proto `figure.caption.separator` záměrně nenastavujeme — v tomto
  // `show` pravidlu se stejně nepoužívá, takže by neměl žádný efekt.
  // Odkaz uprostřed věty zní „tabulka 2.1“ / „obrázek 2.1“ (malé písmeno; Opatření
  // rektorky UO č. 12/2023, čl. 22 odst. 8 a 9). Na začátku věty:
  // `#ref(<label>, supplement: [Tabulka])`. Vlastní `supplement` se nemění.
  show ref: it => {
    let el = it.element
    // Přepisuje se jen výchozí (lokalizovaný) supplement, vlastní zůstává.
    let default-supplement = (
      el != none and el.func() == figure and type(el.supplement) == content
        and el.supplement.has("text") and el.supplement.text in ("Tabulka", "Obrázek", "Table", "Figure")
    )
    if it.supplement == auto and default-supplement and el.kind in (table, image) {
      context {
        let names = if text.lang == "en" { (table: "table", image: "figure") } else { (table: "tabulka", image: "obrázek") }
        ref(it.target, supplement: [#names.at(if el.kind == table { "table" } else { "image" })])
      }
    } else { it }
  }

  show figure.caption: it => {
    // Obrázky mají vlastní mezeru popisku; tabulky/kód/rovnice tu tabulkovou.
    let gap = if it.kind == image { cfg.figure.caption-gap } else { cfg.table.caption-gap }
    [
      #v(gap)
      #it.supplement #it.counter.display(it.numbering)~#it.body
      #v(gap)
    ]
  }

  // Figury (tabulky) se sázejí HNED po textu — menší svislá mezera než mezi
  // odstavci (1,2em), žádné vnitřní odsazení. BEZ `sticky`: dřívější
  // `sticky: it.kind == table` lepilo tabulku k následujícímu obsahu, takže
  // když se nevešla na konec strany, odsunula se celá na další stranu a nad
  // ní zůstalo volné místo. `breakable: true` zajistí, že se dlouhá tabulka
  // místo odsunutí normálně rozlomí přes strany.
  show figure: it => {
    let content = block(
      width: 100%,
      breakable: true,
      spacing: cfg.figure.spacing,
      align(center, it),
    )
    if it.placement == none {
      content
    } else {
      place(it.placement, float: true, content)
    }
  }

  show math.equation.where(block: true): set block(spacing: cfg.figure.spacing)

  body
}
