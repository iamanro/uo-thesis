#import "../internal/i18n/index.typ": t
#import "../../styling/styles.typ": frontmatter-heading
#import "../internal/utils.typ": has-value

// Funkce: render-introduction
// Účel: Vykreslí úvod nebo výchozí vzorový text úvodu.
#let render-introduction(introduction, lang: "cs") = {
  context [
    #frontmatter-heading(t("introduction", lang: lang))
    #if has-value(introduction) {
      introduction
    } else {
      if lang == "en" [
        The introduction expresses the topicality, significance and necessity of the problem being addressed from a theoretical or practical perspective. The introduction does not contain the thesis objective, methods, or a summary of the chapters — these belong in their own dedicated sections. Recommended length: 1–2 pages.
      ] else [
        Úvod vyjadřuje aktuálnost, významnost a potřebnost řešeného problému z hlediska teorie či praxe. V úvodu se nepíše cíl práce, použité metody ani obsah práce. K tomuto účelu slouží samostatné kapitoly závěrečné práce. Doporučený rozsah úvodu je 1–2 normostrany.
      ]
    }
  ]
}
