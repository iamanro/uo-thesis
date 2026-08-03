// Verzálky, které nezvětšují inline kód. `upper()` totiž zvelčí i obsah `raw`:
// nadpis „… a kódem `let x = 1`" se vysází jako „… A KÓDEM LET X = 1", což je
// u kódu špatně (matematika je proti upper() imunní, ta problém nemá).
//
// Rekonstruují se jen sekvence a styled uzly (set/show pravidla) — ty jedině
// lze složit zpět bezztrátově. U ostatních elementů se helper chová jako
// `upper()`, takže nikdy nerozbije strukturu, jen tam kód nezachrání.
#let _styled-func = [#set text(fill: black);x].func()

#let upper-keep-raw(c) = {
  if type(c) == str { return upper(c) }
  if type(c) != content { return c }
  let f = c.func()
  if f == raw { return c }
  if c.has("children") { return c.children.map(upper-keep-raw).join() }
  if f == _styled-func { return (c.func())(upper-keep-raw(c.child), c.fields().styles) }
  upper(c)
}

/// První strana, na které se tiskne číslo. Čítač stránek běží od titulní
/// strany, ale číslo se objeví až od OBSAHU (v draftu hned od první strany).
/// Stav je nutný, protože `set page(footer: …)` platí jen do konce bloku,
/// v němž je zapsaný — přepínáním přes `set` by o čísla přišly bibliografie
/// a přílohy, které se sázejí až za `render-final-layout`.
#let page-numbering-from = state("unob-page-numbering-from", none)

/// Zapne tisk čísel stran od NÁSLEDUJÍCÍ strany. Volá se na konci úvodních
/// částí: samotné volání leží ještě na poslední nečíslované straně (abstrakt),
/// zalomení na OBSAH proběhne až po něm.
#let start-page-numbering-after() = context page-numbering-from.update(here().page() + 1)

/// Vykreslí centrované číslo stránky se zadaným nebo aktuálním číslováním.
#let centered-page-footer(numbering: auto) = context {
  let from = page-numbering-from.at(here())
  if from != none and here().page() >= from {
    set align(center)
    counter(page).display(if numbering == auto { page.numbering } else { numbering })
  }
}

/// Pravidlo pro podnadpisy (úroveň 2–4): tučný blok dané velikosti,
/// s mezerou nad (gap-before) a pod (gap-after) nadpisem.
#let subheading-rule(size, gap-before, gap-after) = it => block(width: 100%)[
  #set text(size: size, weight: "bold")
  #v(gap-before)
  #it
  #v(gap-after)
]

/// Vynuluje čítače lokální pro kapitolu/přílohu.
#let reset-section-counters() = {
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(math.equation).update(0)
}

/// Vykreslí nečíslovaný H1 nadpis pro přední části a seznamy.
#let frontmatter-heading(title, bookmarked: true, outlined: true) = {
  heading(numbering: none, bookmarked: bookmarked, outlined: outlined, level: 1)[#title]
}
