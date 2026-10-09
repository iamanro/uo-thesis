// Autorské pomůcky exportované z lib.typ: `todo`, `note`, `landscape`, `conclusion`.
#import "utils.typ": is-draft-mode
#import "i18n/index.typ": current-lang, t

// Interní: barevný „callout", který se vysází JEN v draft režimu.
#let _callout(fill, label-text, body) = context {
  if is-draft-mode() {
    box(
      fill: fill,
      inset: (x: 4pt, y: 2pt),
      radius: 2pt,
      text(size: 0.85em, fill: black)[#strong(label-text): #body],
    )
  }
}

// Funkce: todo
// Co: Nevyřešená poznámka pro autora. V draftu žlutý štítek, ve finále nic
//     viditelného. Vždy vloží značku `<unob-todo>`, kterou `submit_check: true`
//     najde a odmítne odevzdání s nevyřešenými TODO.
#let todo(body) = {
  [#metadata(true)<unob-todo>]
  _callout(rgb("#fff3b0"), "TODO", body)
}

// Funkce: note
// Co: Informativní poznámka. V draftu modrý štítek, ve finále nic. Neblokuje
//     `submit_check` (na rozdíl od `todo`).
#let note(body) = {
  _callout(rgb("#cfe8ff"), "NOTE", body)
}

// Funkce: landscape
// Co: Otočí obsah (tabulku/obrázek) o 90° na stojaté straně — stránka zůstává
//     na výšku, číslo strany i záhlaví drží normální polohu. Horní okraj
//     obsahu míří k hřbetu (čtenář otáčí dokument po směru hodin). Obalte jím
//     celou figuru: `#landscape[#figure(table(...), caption: [...])]`.
//     Obsah dostane celou stranu a musí se na ni vejít (rotace se nezalamuje).
#let landscape(body) = {
  pagebreak(weak: true)
  layout(size => block(
    width: 100%,
    height: size.height,
    align(center + horizon, rotate(
      -90deg,
      reflow: true,
      // Šířka PŘED rotací = výška sazebního obrazce PO rotaci.
      block(width: size.height, body),
    )),
  ))
  pagebreak(weak: true)
}

// Funkce: conclusion
// Co: Vloží lokalizovaný nadpis závěru a obsah kapitoly.
#let conclusion(content) = context [
  #heading(level: 1, outlined: true, numbering: none)[#t("conclusion", lang: current-lang())]
  #content
]
