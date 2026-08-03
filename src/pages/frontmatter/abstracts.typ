#import "../../styling/styles.typ": frontmatter-heading
#import "../internal/utils.typ": has-value

// Funkce: render-abstract-block
// Účel: Vykreslí jeden jazykový blok abstraktu s nadpisem a klíčovými slovy.
#let render-abstract-block(
  heading_text,
  keyword_label,
  content,
  keywords,
  placeholder: none,
  keywords_placeholder: [],
  heading_renderer: frontmatter-heading,
  indent_keywords: true,
  show_keywords_without_content: false,
) = {
  let keyword_indent = if indent_keywords { h(-7mm) } else { [] }
  let render_keywords(value) = [
    #keyword_indent*#keyword_label*: #value
  ]

  heading_renderer(heading_text)
  if has-value(content) {
    content
    parbreak()
    render_keywords(keywords)
  } else if placeholder != none {
    placeholder
    parbreak()
    render_keywords(if has-value(keywords) { keywords } else { keywords_placeholder })
  } else if show_keywords_without_content {
    render_keywords(keywords)
  }
}

// Funkce: render-abstracts
// Účel: Vykreslí český a anglický abstrakt včetně klíčových slov.
#let render-abstracts(abstract, keywords) = {
  render-abstract-block(
    [ABSTRAKT],
    [Klíčová slova],
    abstract.czech,
    keywords.czech,
    placeholder: [Abstrakt představuje stručnou a přesnou charakteristiku obsahu závěrečné práce, poskytuje informace o problému, způsobu řešení a dosažených výsledcích práce. Rozsah abstraktu v českém jazyce do jedné #footnote[Jako pomocník pro vypracování možné využít: ČSN ISO 214 Dokumentace – abstrakty pro publikace a dokumentaci, případně: https://www.herout.net/blog/2013/12/jak-psat-abstrakt]strany.],
    keywords_placeholder: [ uvádí se 5–10 klíčových slov (= hesla, sousloví a fráze) v abecedním pořadí, které charakterizují obsahovou podstatu závěrečné práce],
  )

  render-abstract-block(
    [ABSTRACT],
    [Keywords],
    abstract.english,
    keywords.english,
    placeholder: [Text abstraktu v anglickém jazyce.],
  )
}
