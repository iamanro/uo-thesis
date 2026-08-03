// Flexibilní popisky figur: dlouhá verze (např. s „Zdroj: …") se sází pod figurou,
// krátká verze v seznamu obrázků/tabulek.
//
// Použití v obsahu práce:
//   #figure(image("..."),
//     caption: flex-caption(
//       [Popisek; Zdroj: …],   // dlouhá verze (pod figurou)
//       [Popisek]),            // krátká verze (do seznamu)
//   )<fig:...>

#let in-outline = state("in-outline", false)

#let flex-caption(long, short) = context if in-outline.get() { short } else { long }

// Show-rule aplikátor: po dobu sazby libovolného outline přepne stav na „v seznamu",
// takže flex-caption v popiscích vrátí krátkou verzi. Aplikuje se v hlavní šabloně
// (unob-thesis), aby platil i pro šablonové SEZNAM OBRÁZKŮ / SEZNAM TABULEK.
#let apply-flex-caption-outline(body) = {
  show outline: it => {
    in-outline.update(true)
    it
    in-outline.update(false)
  }
  body
}
