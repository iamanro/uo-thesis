#import "../internal/i18n/index.typ": t
#import "../../styling/styles.typ": frontmatter-heading
#import "../internal/utils.typ": has-value

// Funkce: render-acknowledgement
// Účel: Vykreslí poděkování nebo výchozí vzorový text.
#let render-acknowledgement(acknowledgement, lang: "cs") = {
  context if acknowledgement != false {
    frontmatter-heading(t("acknowledgement", lang: lang))

    if has-value(acknowledgement) {
      acknowledgement
    } else if lang == "en" {
      [Acknowledgement text \ Acknowledgements are not a mandatory part of the thesis. It is appropriate to express gratitude to parents, the thesis supervisor, consultants, or anyone who helped or supported you during the work or your studies.]
    } else {
      [Text poděkování \ Poděkování není povinnou součástí závěrečné práce. Je vhodné vyjádřit poděkování rodičům, vedoucímu závěrečné práce, konzultantům či osobám, které Vám pomohly / byly nápomocny při zpracování závěrečné práce nebo v průběhu studia.]
    }
  }
}
