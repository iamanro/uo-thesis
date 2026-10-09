#import "internal/i18n/index.typ": t, thesis-type-is-bachelor-or-master, thesis-type-is-doctoral
#import "internal/utils.typ": has-person, has-value
#import "internal/people.typ": format-name
#import "internal/localization.typ": get-city-name, get-faculty-name, get-thesis-type-name
#import "../styling/theme.typ": get-logo-path
#import "../config.typ": cfg

/// Vizuální parametry titulní strany (hodnoty v config.toml → [cover]).
/// Jednotná mezera `gap` se používá mezi všemi bloky titulky.
#let cover-vars = (
  logo_height: cfg.cover.logo-height,

  size_header: cfg.cover.size-header, // fakulta, program, specializace
  size_university: cfg.cover.size-university,
  size_thesis_type: cfg.cover.size-thesis-type,
  size_title: cfg.cover.size-title,
  size_people: cfg.cover.size-people,
  size_city_year: cfg.cover.size-city-year,

  gap_after_header: cfg.cover.gap,
  gap_after_logo: cfg.cover.gap,
  gap_after_thesis_type: cfg.cover.gap,
  gap_after_people: cfg.cover.gap,

  paragraph_leading: cfg.cover.paragraph-leading,
  title_leading: cfg.cover.title-leading,
)

/// Vykreslí titulní stranu práce podle konfigurace školy, práce a osob.
///
/// Rozvržení: jediný blok přes celou výšku strany, obsah plyne shora dolů.
/// Všechny části kromě názvu práce jsou na pevném místě — horní skupina
/// (hlavička, logo, typ práce, název) drží nahoře díky pevným mezerám v(),
/// jediné v(1fr) po názvu odsune dolní skupinu (osoby, město + rok) k dolnímu
/// okraji. Název je tak jediný proměnlivě dlouhý prvek. Bez pevně vysokých
/// bloků a bez align(...+horizon), takže nedochází k překryvu.
#let render-cover(
  config,
  lang: "cs",
  vars: cover-vars,
) = {
  let university = config.university
  let thesis = config.thesis
  let author = config.author
  let supervisor = config.supervisor
  let first_advisor = config.first_advisor
  let second_advisor = config.second_advisor

  show heading: none
  context heading(
    numbering: none,
    bookmarked: true,
    level: 1,
    outlined: false,
  )[ #t("title_page", lang: lang) ]

  set par(first-line-indent: 0mm)
  set page(footer: none)

  // Popisek s hodnotou (např. „Studijní program: …“); prázdné vrací none.
  let labeled-value(label_key, value) = if has-value(value) {
    [#t(label_key, lang: lang)#value]
  } else {
    none
  }

  // Popisek role se liší podle typu práce (bakalářská/magisterská vs. doktorská).
  let role-label(primary_key, alternate_key) = if thesis-type-is-bachelor-or-master(thesis.type) {
    t(primary_key, lang: lang)
  } else {
    t(alternate_key, lang: lang)
  }

  // Řádek osoby vykreslíme jen tehdy, je-li osoba vyplněná (jinak none).
  let person-row(person, label) = if has-person(person) {
    [#label#format-name(person)]
  } else {
    none
  }

  // Poskládá jen neprázdné řádky pod sebe — zlomy jen mezi řádky, bez koncového.
  let stack-lines(lines) = lines.filter(l => l != none).join(linebreak())

  let logo-alt = if lang == "en" { "University of Defence logo" } else { "Logo Univerzity obrany" }

  // Hlavička: název školy je vždy, fakulta se skryje pro `uo`, program
  // a specializace jen pokud jsou vyplněné.
  let header_lines = (
    text(size: vars.size_university, upper(t("university_name", lang: lang))),
    if university.faculty != "uo" {
      strong(upper(get-faculty-name(university.faculty, lang: lang)))
    },
    if has-value(university.programme) {
      strong(labeled-value("programme_label", university.programme))
    },
    // Bc./Ing. mají „Studijní specializace", Ph.D. „Zaměření studia".
    labeled-value(
      if thesis-type-is-doctoral(thesis.type) { "specialisation_label_doctoral" } else { "specialisation_label" },
      university.specialisation,
    ),
  )

  // Řádky osob: autor je vždy, ostatní jen pokud jsou vyplněny.
  let author_label = if author.sex != "F" { t("author_male", lang: lang) } else { t("author_female", lang: lang) }
  let people_lines = (
    [#author_label #format-name(author)],
    person-row(supervisor, role-label("supervisor_work_label", "supervisor_label")),
    person-row(first_advisor, role-label("advisor_label", "co_supervisor_label")),
    if thesis-type-is-doctoral(thesis.type) {
      person-row(second_advisor, t("co_supervisor_label", lang: lang))
    },
  )

  context block(width: 100%, height: 100%)[
    #set par(first-line-indent: 0mm, leading: vars.paragraph_leading, justify: false)

    // Horní hlavička – univerzita, fakulta, program, specializace (pevně nahoře).
    #align(center)[
      #set text(size: vars.size_header)
      #stack-lines(header_lines)
    ]

    #v(vars.gap_after_header)

    // Logo – pevně pod hlavičkou.
    #align(center)[
      #image(get-logo-path(university.faculty), alt: logo-alt, height: vars.logo_height, width: auto)
    ]

    #v(vars.gap_after_logo)

    // Typ práce (např. DISERTAČNÍ PRÁCE) – pevně pod logem.
    #align(center)[
      #set text(size: vars.size_thesis_type, weight: "bold")
      #upper(get-thesis-type-name(thesis.type, lang: lang))
    ]

    #v(vars.gap_after_thesis_type)

    // Název práce – jediná proměnlivě dlouhá část.
    #align(center)[
      // Sémantický element `title` (přístupnost/PDF-UA); show rule potlačí
      // výchozí blokovou sazbu, set text dorovná vzhled titulku.
      #show title: it => it.body
      #set text(size: vars.size_title, weight: "bold", hyphenate: false)
      #set par(leading: vars.title_leading)
      #title(thesis.title)
    ]

    // Jediná pružná mezera – odsune dolní skupinu k patě strany.
    #v(1fr)

    // Dolní skupina – autor a vedoucí/školitel, ukotvená k dolnímu okraji.
    #align(left)[
      #set text(size: vars.size_people)
      #stack-lines(people_lines)
    ]

    #v(vars.gap_after_people)

    // Město a rok – zcela dole na straně.
    #align(center)[
      #set text(size: vars.size_city_year)
      #upper(get-city-name(university.faculty, lang: lang))#datetime.today().display(" [year]")
    ]
  ]
}
