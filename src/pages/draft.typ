#import "frontmatter/abstracts.typ": render-abstract-block
#import "internal/utils.typ": has-value
#import "internal/people.typ": format-name
#import "internal/localization.typ": get-thesis-type-name

/// Vrátí stručné jméno autora bez titulů pro hlavičku draftu.
#let format-author-name-for-draft(author) = {
  if has-value(author.name) and has-value(author.surname) {
    [#author.name #author.surname]
  } else if has-value(author.name) {
    [#author.name]
  } else if has-value(author.surname) {
    [#author.surname]
  } else {
    format-name(author)
  }
}

/// Vykreslí nadpis abstraktu bez záložky a položky v obsahu.
#let draft-abstract-heading(title) = {
  heading(numbering: none, outlined: false, bookmarked: false, level: 1)[#title]
}

#let render-draft-abstract-block(title, keyword_label, content, keywords, show_keywords) = {
  block(width: 100%)[
    #set align(center)
    #render-abstract-block(
      title,
      keyword_label,
      content,
      keywords,
      heading_renderer: draft-abstract-heading,
      indent_keywords: false,
      show_keywords_without_content: show_keywords,
    )
  ]
}

/// Vykreslí minimalistickou hlavičku draftu.
#let render-draft-header(thesis, author, lang: "cs") = context {
  set par(first-line-indent: 0mm)
  set align(center)

  text(size: 18pt, weight: "bold")[#thesis.title]
  parbreak()

  format-author-name-for-draft(author)
  parbreak()

  let draft_banner = if lang == "en" {
    [DRAFT #upper(get-thesis-type-name(thesis.type, variant: 1, lang: lang))]
  } else {
    [DRAFT #upper(get-thesis-type-name(thesis.type, variant: 2, lang: lang))]
  }
  text(size: 11pt, style: "italic")[#draft_banner]

  v(1.2em)
  set align(left)
}

/// Vykreslí jen vyplněné abstrakty a klíčová slova.
#let render-draft-abstracts(abstract, keywords) = context {
  let has_cs_abstract = has-value(abstract.czech)
  let has_en_abstract = has-value(abstract.english)
  let has_cs_keywords = has-value(keywords.czech)
  let has_en_keywords = has-value(keywords.english)
  let has_cs_block = has_cs_abstract or has_cs_keywords
  let has_en_block = has_en_abstract or has_en_keywords

  if has_cs_block or has_en_block {
    grid(
      columns: (1fr, 1fr),
      column-gutter: 8mm,
      row-gutter: 0mm,
      [
        #if has_cs_block {
          render-draft-abstract-block([ABSTRAKT], [Klíčová slova], abstract.czech, keywords.czech, has_cs_keywords)
        }
      ],
      [
        #if has_en_block {
          render-draft-abstract-block([ABSTRACT], [Keywords], abstract.english, keywords.english, has_en_keywords)
        }
      ],
    )
    parbreak()
  }
}
