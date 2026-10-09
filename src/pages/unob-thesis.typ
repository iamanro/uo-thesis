#import "internal/i18n/index.typ": normalize-thesis-type as i18n-normalize-thesis-type, setup-language
#import "../styling/base.typ": apply-base-styles
#import "../styling/figures.typ": apply-figure-styles
#import "../styling/headings.typ": apply-heading-styles
#import "../styling/theme.typ": resolve-theme
#import "../styling/flex-caption.typ": apply-flex-caption-outline
#import "appendix.typ": appendix as render-appendix
#import "render.typ": render-draft-layout, render-final-layout
#import "internal/validation.typ": validate-config, validate-submit-check, validate-image-alt, validate-no-todos, validate-bibliography
#import "internal/config.typ": normalize-outlines, normalize-theme-config
#import "internal/people.typ": person
#import "internal/glossary/parse.typ": (
  glossary-to-acronyms, glossary-to-symbols, glossary-to-terms, normalize-glossary-input,
  validate-glossary-registry,
)
#import "internal/glossary/runtime.typ": init-glossary-runtime

// Funkce: unob-thesis
// Účel: Hlavní veřejný vstup šablony s inline konfigurací po vzoru SHAW/ZHAW.
#let unob-thesis(
  body,
  lang: "cs",
  draft: false,
  faculty: "uo",
  programme: [],
  specialisation: [],
  thesis: (
    type: "bachelor",
    title: [Název práce],
  ),
  author: person(name: "Jan", surname: "Novák", sex: "M"),
  supervisor: person(name: "Jana", surname: "Nováková", sex: "F"),
  first_advisor: person(),
  second_advisor: person(),
  assignment_front: none,
  assignment_back: none,
  acknowledgement: false,
   declaration: true,
  ai_used: false,
  acronyms: false,
  terms: false,
  symbols: false,
  abstract: (
    czech: [],
    english: [],
  ),
  keywords: (
    czech: "",
    english: "",
  ),
  theme: (
    color: false,
    links_colored: true,
    faculty_colored: true,
    faculty_color: none,
    link_color: none,
  ),
  introduction: [],
  outlines: (
    headings: true,
    acronyms: false,
    terms: false,
    figures: true,
    tables: true,
    equations: false,
    listings: false,
  ),
  submit_check: false,
  vlna: auto,
  fancy_heading: false,
  twoside: true,
  bibliography: none,
  appendix: none,
) = {
  show: setup-language.with(lang: lang)

  // Časná kontrola tvaru `thesis` — čte se dříve než běží `validate-config`,
  // takže bez ní by chybějící klíč skončil nesrozumitelnou chybou Typstu.
  if type(thesis) != dictionary or thesis.at("type", default: none) == none or thesis.at("title", default: none) == none {
    panic(
      "Parametr `thesis` musí být slovník s klíči `type` a `title`, např. "
        + "`thesis: (type: \"master\", title: \"Název práce\")`. / "
        + "`thesis` must be a dictionary with `type` and `title`.",
    )
  }

  let university = (faculty: faculty, programme: programme, specialisation: specialisation)
  let assignment = (front: assignment_front, back: assignment_back)
  let declaration_config = (declaration: declaration, ai_used: ai_used)
  let outline_config = normalize-outlines(outlines)
  let theme_config = normalize-theme-config(theme)

  let normalized_thesis = (
    type: i18n-normalize-thesis-type(thesis.type),
    title: thesis.title,
  )

  // Zkratky, pojmy i symboly čtou JEDEN glosář; `true` = demo glossary.toml z balíčku.
  let glossary_sources = (acronyms, terms, symbols)
    .filter(source => source != false and source != none)
    .map(source => if source == true { toml("../../template/glossary.toml") } else { source })
    .dedup()
  if glossary_sources.len() > 1 {
    panic(
      "Parametry `acronyms`, `terms` a `symbols` musí předat tentýž glosář. / "
        + "`acronyms`, `terms` and `symbols` must pass the same glossary.",
    )
  }
  let glossary_entries = normalize-glossary-input(glossary_sources.at(0, default: false))
  let want-acronyms = acronyms != false and acronyms != none
  let want-terms = terms != false and terms != none
  let want-symbols = symbols != false and symbols != none
  let resolved_acronyms = if want-acronyms { glossary-to-acronyms(glossary_entries) } else { false }
  let resolved_terms = if want-terms { glossary-to-terms(glossary_entries) } else { false }
  let resolved_symbols = if want-symbols { glossary-to-symbols(glossary_entries) } else { false }

  // Seznamy glosáře se zobrazí jen pokud glosář obsahuje položky daného druhu.
  let effective-outlines = outline_config + (
    acronyms: resolved_acronyms != false and outline_config.acronyms,
    terms: resolved_terms != false and outline_config.terms,
    symbols: resolved_symbols != false and outline_config.symbols,
  )

  let effective-theme = resolve-theme(theme_config, university.faculty)

  validate-glossary-registry(resolved_acronyms, resolved_terms, symbols: resolved_symbols)

  // `vlna: auto` — nezlomitelné mezery řeší finální řádkové zlomy; v draftu
  // (jiné okraje, jiné zlomy) je jejich kontrola bezcenná a vlna jen zdražuje
  // psací smyčku (+40–75 % času kompilace). Explicitní true/false vždy vyhrává.
  let effective-vlna = if vlna == auto { draft != true } else { vlna }

  validate-config((
    draft: draft,
    university: university,
    thesis: thesis,
    author: author,
    supervisor: supervisor,
    first_advisor: first_advisor,
    second_advisor: second_advisor,
    declaration: declaration_config,
    assignment: assignment,
    outlines: effective-outlines,
    acronyms: resolved_acronyms,
    terms: resolved_terms,
    symbols: resolved_symbols,
    submit_check: submit_check,
    vlna: effective-vlna,
    fancy_heading: fancy_heading,
    twoside: twoside,
  ))

  validate-bibliography(bibliography)

  validate-submit-check(submit_check, (
    draft: draft,
    thesis: thesis,
    author: author,
    supervisor: supervisor,
    abstract: abstract,
    keywords: keywords,
    introduction: introduction,
    assignment: assignment,
    bibliography: bibliography,
  ))

  validate-image-alt(submit_check, lang)
  validate-no-todos(submit_check, lang)

  show: apply-base-styles.with(
    draft: draft,
    lang: lang,
    author: author,
    thesis: normalized_thesis,
    abstract: abstract,
    keywords: keywords,
    theme: effective-theme,
    vlna: effective-vlna,
    fancy_heading: fancy_heading,
    twoside: twoside,
  )
  show: apply-heading-styles.with(draft: draft, twoside: twoside)
  show: apply-figure-styles
  // Přepínání dlouhá/krátká verze popisků (flex-caption) i v šablonových seznamech.
  show: apply-flex-caption-outline

  [#metadata(draft) <unob-layout-draft>]
  init-glossary-runtime(resolved_acronyms, terms: resolved_terms)

  if draft {
    render-draft-layout(
      normalized_thesis,
      author,
      abstract,
      keywords,
      body,
      lang: lang,
    )
  } else {
    render-final-layout(
      (
        university: university,
        thesis: normalized_thesis,
        author: author,
        supervisor: supervisor,
        first_advisor: first_advisor,
        second_advisor: second_advisor,
        assignment: assignment,
        declaration: declaration_config,
        acknowledgement: acknowledgement,
        abstract: abstract,
        keywords: keywords,
        outlines: effective-outlines,
        glossary: (acronyms: resolved_acronyms, terms: resolved_terms, symbols: resolved_symbols),
        introduction: introduction,
      ),
      body,
      lang: lang,
    )
  }

  if bibliography != none {
    // Podpora jedné i více bibliografií (Typst 0.15+)
    let bibs = if type(bibliography) == array { bibliography } else { (bibliography,) }
    for bib in bibs {
      bib
    }
  }
  if appendix != none {
    render-appendix(draft: draft, lang: lang, twoside: twoside)[#appendix]
  }
}
