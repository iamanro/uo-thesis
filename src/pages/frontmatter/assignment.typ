#import "../internal/i18n/index.typ": t

// Funkce: render-assignment-page
// Účel: Vykreslí jednu stranu zadání nebo lokalizovaný placeholder.
#let render-assignment-page(content, lang: "cs") = {
  set par(first-line-indent: 0mm)
  if content == none {
    place(center + horizon)[
      #text(style: "italic")[#t("assignment_placement", lang: lang)]
    ]
  } else if content == false  {
  } else {
    content
  }
}

// Funkce: render-assignment
// Účel: Za titulní stranu vloží rub titulního listu a oboustranné zadání.
#let render-assignment(assignment, lang: "cs") = {
  let front = if type(assignment) == dictionary { assignment.at("front", default: false) } else { false }
  let back = if type(assignment) == dictionary { assignment.at("back", default: false) } else { false }

  if front == false and back == false {
    // Zadání vypnuté — vysází se jen prázdný rub titulní strany (za titulní
    // stranou je vždy jedna volná strana kvůli oboustrannému tisku). Následující
    // sekce (PODĚKOVÁNÍ) skočí na líc sama díky pagebreaku ve svém H1 nadpisu.
    pagebreak()
  } else {
    // První pagebreak vytvoří rub titulní strany, druhý přejde na líc zadání.
    pagebreak()
    pagebreak()
    render-assignment-page(front, lang: lang)
    pagebreak()
    render-assignment-page(back, lang: lang)
  }
}
