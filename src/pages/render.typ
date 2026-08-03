#import "../styling/styles.typ": page-numbering-from, start-page-numbering-after
#import "cover.typ": render-cover
#import "draft.typ": render-draft-abstracts, render-draft-header
#import "frontmatter.typ": (
  render-abstracts, render-acknowledgement, render-assignment, render-declaration, render-introduction,
)
#import "lists.typ": render-lists
#import "../styling/running-header.typ": body-started

#let render-draft-layout(thesis, author, abstract, keywords, body, lang: "cs") = {
  // Draft: čísluje se od první strany.
  page-numbering-from.update(1)
  render-draft-header(thesis, author, lang: lang)
  render-draft-abstracts(abstract, keywords)
  body
}

#let render-final-layout(config, body, lang: "cs") = {
  let (
    university, thesis, author, supervisor, first_advisor, second_advisor, assignment,
    declaration, acknowledgement, abstract, keywords, outlines, glossary, introduction,
  ) = config

  render-cover(
    (
      university: university,
      thesis: thesis,
      author: author,
      supervisor: supervisor,
      first_advisor: first_advisor,
      second_advisor: second_advisor,
    ),
    lang: lang,
  )

  render-assignment(assignment, lang: lang)
  render-acknowledgement(acknowledgement, lang: lang)
  render-declaration(
    (
      declaration: declaration,
      author: author,
      supervisor: supervisor,
      university: university,
      thesis: thesis,
    ),
    lang: lang,
  )
  render-abstracts(abstract, keywords)
  // Od OBSAHU dál se tiskne číslo strany. Čítač běží PRŮBĚŽNĚ od titulní strany
  // (titulka a úvodní části se počítají, jen se na nich číslo netiskne), takže
  // čísla v OBSAHU odpovídají skutečné pozici listu a lichá čísla zůstávají na
  // líci — s tím počítá `pagebreak(to: "odd")` u kapitol. Nulovat tu čítač
  // NELZE: zalomení na líc (H1 nadpis OBSAHU) proběhne až po nulování, takže by
  // posunulo celou řadu o jedna a převrátilo paritu lichá/sudá.
  start-page-numbering-after()
  render-lists(outlines, glossary, lang: lang)
  render-introduction(introduction, lang: lang)
  // Od tohoto místa dál (tělo práce) smí běžné záhlaví (fancy_heading) sázet
  // název kapitoly; před tělem (obálka, úvodní části, seznamy) je potlačeno.
  body-started.update(true)
  body
}
