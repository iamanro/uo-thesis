// Úvodní části finální práce v pořadí sazby: zadání, poděkování, čestné
// prohlášení, abstrakty, úvod.
#import "internal/i18n/index.typ": city-name, faculty-name, t, thesis-type-is-bachelor-or-master, thesis-type-name
#import "internal/people.typ": format-name, format-supervisor-for-declaration
#import "internal/utils.typ": has-value
#import "../styling/helpers.typ": frontmatter-heading

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

// Funkce: _gendered
// Účel: Vrátí `male_form` nebo `female_form` podle pohlaví autora.
// Pro `sex: none` použije mužský tvar (shodně s titulní stranou).
#let _gendered(sex, male_form, female_form) = if sex == "F" { female_form } else { male_form }

// Funkce: render-declaration
// Účel: Vykreslí čestné prohlášení vždy v českém jazyce.
#let render-declaration(
  config,
  lang: "cs",
) = {
  let declaration = config.declaration
  let author = config.author
  let supervisor = config.supervisor
  let university = config.university
  let thesis = config.thesis
  let thesis_type = variant => text(lang: "cs")[#thesis-type-name(
    thesis.type,
    variant: variant,
    lang: "cs",
  )]
  let supervisor_role = if thesis-type-is-bachelor-or-master(thesis.type) {
    _gendered(supervisor.sex, [vedoucího práce], [vedoucí práce])
  } else {
    _gendered(supervisor.sex, [školitele], [školitelky])
  }

  context if declaration.declaration != false {
    frontmatter-heading(t("declaration", lang: lang))

    [
      Prohlašuji, že jsem zadanou #thesis_type(3)
      na téma #emph[#thesis.title] #_gendered(author.sex, [vypracoval], [vypracovala]) samostatně, pod odborným vedením
      #supervisor_role
      #format-supervisor-for-declaration(supervisor) a~#_gendered(author.sex, [použil], [použila]) jsem pouze literární zdroje uvedené v práci.

      #parbreak()

      Dále prohlašuji, že při vytváření této práce jsem
      #if declaration.ai_used != false {
        _gendered(author.sex, [použil], [použila])
        [
          nástroje umělé inteligence. Tyto nástroje byly využity v souladu s platnými obecně závaznými právními předpisy, vnitřními předpisy
          Univerzity obrany#if university.faculty != "uo" [ a #text(lang: "cs")[#faculty-name(university.faculty, variant: 2, lang: "cs")]]
          a etickými normami.
        ]
      } else {
        _gendered(author.sex, [nepoužil], [nepoužila])
        [ nástroje umělé inteligence. ]
      }

      #parbreak()

      Dále prohlašuji, že jsem
      #_gendered(author.sex, [seznámen], [seznámena])
      s tím, že se na moji #thesis_type(3)
      vztahují práva a~povinnosti vyplývající ze zákona č. 121/2000 Sb., o právu autorském,
      o právech souvisejících s právem autorským a o změně některých zákonů
      (autorský zákon), ve znění pozdějších předpisů, zejména skutečnosti,
      že Univerzita obrany má právo na uzavření licenční smlouvy o užití
      této #thesis_type(2)
      jako školního díla
      podle §~60~odst.~1 výše uvedeného zákona, a s tím, že pokud dojde k
      užití této #thesis_type(2)
      mnou nebo
      bude poskytnuta licence o užití díla třetímu subjektu, je Univerzita
      obrany oprávněna ode mne požadovat přiměřený příspěvek na úhradu
      nákladů, které na vytvoření díla vynaložila, a~to~podle okolností až
      do jejich skutečné výše.

      #parbreak()

      Souhlasím se zpřístupněním své
      #thesis_type(2)
      pro prezenční studium v prostorách knihovny Univerzity obrany.

      #v(2cm)
      #align(center, grid(
        align: (left, center),
        columns: (50%, 50%),
        rows: 2,
        [
          V #city-name(university.faculty, variant: 2, lang: "cs"),
          dne #datetime.today().display("[day padding:none]. [month padding:none]. [year]")
        ],
        [#box(width: 1fr, repeat[.])],

        v(.5cm), [],
        [], [#format-name(author)],
      ))
    ]
  }
}

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
