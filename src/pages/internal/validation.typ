#import "utils.typ": has-person, has-value, plain-text
#import "i18n/index.typ": (
  current-lang, is-supported-faculty, is-supported-language, is-supported-thesis-type, t,
)
#import "i18n/data.typ": translations
#import "people.typ": validate-person

// Funkce: panic-i18n
// Účel: Vyvolá chybu na základě i18n klíče.
// `t(key)` bez `lang` vrací `context` (viz i18n/with-lang), takže `panic(t(key))`
// panikařil hláškou „context()" a uživatel se nikdy nedozvěděl, co opravit.
// Jazyk se proto musí vyhodnotit UVNITŘ kontextu a předat explicitně.
#let panic-i18n(key) = context {
  panic(t(key, lang: current-lang()))
}

// Funkce: panic-bilingual
// Účel: Vyvolá dvojjazyčnou chybu (cs / en) bez závislosti na kontextu.
//       Používá se v místech mimo sazbu, kde `panic-i18n` nelze použít.
#let panic-bilingual(key) = {
  let message = translations.at(key)
  panic(message.cs + " / " + message.en)
}

// Přípustné hodnoty strany zadání: `none` (placeholder), `false` (strana se
// vůbec nevykreslí) nebo `content` (vlastní obsah zadání).
#let validate-assignment-page(value) = {
  if value != none and value != false and type(value) != content {
    panic-i18n("error_assignment_content")
  }
}

// Funkce: validate-bibliography
// Účel: Ověří, že `bibliography` je `none`, nativní hodnota `bibliography(...)`
//       nebo pole takových hodnot. Předání cesty jako řetězce (běžná chyba)
//       vyvolá jasnou dvojjazyčnou chybu s ukázkou správného použití.
#let validate-bibliography(value) = {
  let is-bib(v) = type(v) == content and v.func() == bibliography
  let ok = value == none or is-bib(value) or (type(value) == array and value.all(is-bib))
  if not ok {
    panic-bilingual("error_bibliography_type")
  }
}

// Funkce: validate-config
// Účel: Ověří vstupní konfiguraci šablony a při chybě vyvolá `panic`.
// Přijímá jeden slovník `config` (pojmenované klíče místo pořadí argumentů).
#let validate-config(config) = {
  let (
    lang, draft, university, thesis, author, supervisor, first_advisor, second_advisor,
    declaration, assignment, outlines, acronyms, terms, symbols, docs, submit_check,
    vlna, fancy_heading, twoside,
  ) = config

  if not is-supported-language(lang) {
    panic-i18n("error_unsupported_language")
  }

  if type(draft) != bool {
    panic-i18n("error_draft_bool")
  }

  if not is-supported-faculty(university.faculty) {
    panic-i18n("error_unsupported_faculty")
  }

  if not is-supported-thesis-type(thesis.type) {
    panic-i18n("error_unsupported_thesis_type")
  }

  if not has-value(thesis.title) {
    panic-i18n("error_title_required")
  }

  if not has-person(author) {
    panic-i18n("error_author_required")
  }

  validate-person(author, "person_role_author")
  validate-person(supervisor, "person_role_supervisor")
  validate-person(first_advisor, "person_role_first_advisor")
  validate-person(second_advisor, "person_role_second_advisor")

  if declaration.declaration != false and not has-person(supervisor) {
    panic-i18n("error_supervisor_required_for_declaration")
  }

  if outlines.acronyms != false and type(acronyms) != dictionary {
    panic-i18n("error_outlines_acronyms_requires_dictionary")
  }

  if outlines.terms != false and type(terms) != dictionary {
    panic-i18n("error_outlines_terms_requires_dictionary")
  }

  if outlines.at("symbols", default: false) != false and type(symbols) != dictionary {
    panic-i18n("error_outlines_symbols_requires_dictionary")
  }

  if type(vlna) != bool {
    panic-i18n("error_vlna_bool")
  }

  if type(fancy_heading) != bool {
    panic-i18n("error_fancy_heading_bool")
  }

  if type(twoside) != bool {
    panic-i18n("error_twoside_bool")
  }

  if type(docs) != bool {
    panic-i18n("error_docs_bool")
  }

  if type(declaration.declaration) != bool or type(declaration.ai_used) != bool {
    panic-i18n("error_declaration_bool")
  }

  validate-assignment-page(assignment.front)
  validate-assignment-page(assignment.back)

  if type(submit_check) != bool {
    panic-i18n("error_submit_check_bool")
  }
}

// Funkce: validate-submit-check
// Účel: V přísném režimu ověří minimální náležitosti před odevzdáním.
//       `submitted` nese hodnoty předané šabloně (draft, osoby, abstrakt, …).
#let validate-submit-check(submit_check, submitted) = {
  if submit_check != true {
    return
  }
  let (draft, thesis, author, supervisor, abstract, keywords, introduction, assignment, bibliography) = submitted

  let require_value(value, error_key) = {
    if not has-value(value) {
      panic-i18n(error_key)
    }
  }

  if draft == true {
    panic-i18n("error_submit_check_draft_disabled")
  }

  if not has-person(supervisor) {
    panic-i18n("error_submit_check_supervisor_required")
  }

  require_value(abstract.czech, "error_submit_check_abstract_cs_required")
  require_value(abstract.english, "error_submit_check_abstract_en_required")
  require_value(keywords.czech, "error_submit_check_keywords_cs_required")
  require_value(keywords.english, "error_submit_check_keywords_en_required")
  require_value(introduction, "error_submit_check_introduction_required")
  require_value(bibliography, "error_submit_check_bibliography_required")

  // Minimální počet klíčových slov (běžný požadavek 3–5). Počítá neprázdné
  // položky oddělené čárkou.
  let keyword_count(value) = if type(value) == str {
    value.split(",").filter(k => k.trim().len() > 0).len()
  } else { 0 }
  if keyword_count(keywords.czech) < 3 {
    panic-i18n("error_submit_check_keywords_cs_min")
  }
  if keyword_count(keywords.english) < 3 {
    panic-i18n("error_submit_check_keywords_en_min")
  }

  // Ukázkové (needitované) hodnoty ze šablony. Porovnává se celý text, aby
  // se legitimní text nezablokoval jako podřetězec vzorku.
  if plain-text(thesis.title).trim() == "Název práce" {
    panic-bilingual("error_submit_check_title_sample")
  }
  if author.at("name", default: none) == "Jan" and author.at("surname", default: none) == "Novák" {
    panic-bilingual("error_submit_check_author_sample")
  }
  if plain-text(abstract.czech).trim() == "Český abstrakt práce." {
    panic-bilingual("error_submit_check_abstract_cs_sample")
  }
  if plain-text(abstract.english).trim() == "English abstract of the thesis." {
    panic-bilingual("error_submit_check_abstract_en_sample")
  }
  if keywords.czech == "klíčové slovo 1, klíčové slovo 2, klíčové slovo 3" {
    panic-bilingual("error_submit_check_keywords_cs_sample")
  }
  if keywords.english == "keyword 1, keyword 2, keyword 3" {
    panic-bilingual("error_submit_check_keywords_en_sample")
  }

  if assignment.front == none or assignment.front == false or assignment.back == none or assignment.back == false {
    panic-i18n("error_submit_check_assignment_required")
  }
}

// Funkce: validate-image-alt
// Účel: V přísném režimu (PDF/UA) ověří, že každý vložený obrázek má `alt` text.
//       Dotazuje se `query(image)`, takže pokrývá i skeny zadání
//       (`assignment_front` / `assignment_back`) i obrázky v těle práce.
//       Vrací `context` blok (dotaz na obrázky vyžaduje kontext sazby); při
//       chybě vypíše stranu a zdroj každého obrázku bez `alt`, aby šel dohledat.
#let validate-image-alt(submit_check, lang) = {
  if submit_check != true {
    return
  }

  context {
    let missing = query(image).filter(it => it.at("alt", default: none) == none)
    if missing.len() > 0 {
      let page-label = if lang == "en" { "page " } else { "strana " }
      let describe(it) = {
        let src = it.at("source", default: none)
        let where = if type(src) == str { " (" + src + ")" } else { "" }
        page-label + str(it.location().page()) + where
      }
      panic(t("error_submit_check_image_alt", lang: lang) + " " + missing.map(describe).join("; ") + ".")
    }
  }
}

// Funkce: validate-no-todos
// Účel: V přísném režimu odmítne odevzdání, pokud v dokumentu zůstaly
//       nevyřešené značky `#todo(...)`. Vypíše stranu každého výskytu.
#let validate-no-todos(submit_check, lang) = {
  if submit_check != true {
    return
  }

  context {
    let todos = query(<unob-todo>)
    if todos.len() > 0 {
      let page-label = if lang == "en" { "page " } else { "strana " }
      let where = todos.map(it => page-label + str(it.location().page()))
      panic(t("error_submit_check_todo", lang: lang) + " " + where.join("; ") + ".")
    }
  }
}
