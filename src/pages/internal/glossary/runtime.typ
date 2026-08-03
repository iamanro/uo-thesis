// BEZSTAVOVÝ runtime glosáře.
//
// Dřívější implementace stavěla na balíčku glossarium: každé `#trm` volalo
// `gls()`, které inkrementovalo state `__glossary_counts`, a seznamy ve
// frontmatteru filtrovaly položky přes `count-refs` (čtení `.final()` stavu).
// Obsah seznamů tak závisel na stavu čítačů, který se měnil mezi iteracemi
// sazby (poznámky pod čarou a plovoucí prvky mění pořadí zápisů stavu podle
// stránkování) → dokument nekonvergoval ("document did not converge").
//
// Nový návrh je čistě funkční: `#trm` je pouze vyhledání záznamu + odkaz na
// návěští v SEZNAMU ZKRATEK / SEZNAMU POJMŮ. Jediné čtení stavu je registr
// definic (zapsán PRÁVĚ JEDNOU při inicializaci šablony, nikdy se nemění),
// jediný dotaz je existence návěští (množina návěští je za běhu konstantní).
// Nic zde nezávisí na stránkování → systém nemůže rozbít konvergenci.
#import "./parse.typ": acronym-fields-from-value
#import "./registry.typ": acronyms-registry, registry-definitions, terms-registry
#import "./lookup.typ": find-key-or-short-case-insensitive, link-to-acronym-entry, link-to-term-entry, panic-unknown-key
#import "./declension.typ": build-acronym-first-display

// Dříve `make-glossary` z glossaria (show pravidla pro jeho interní figury).
// Bezstavová verze žádná show pravidla nepotřebuje — identita kvůli API.
#let glossary-show(body) = body

#let singular = "singular"
#let plural = "plural"
#let first = "first"
#let first-plural = "first_plural"

// Pozn.: validace panikuje PŘÍMO (`panic(...)`), ne přes `panic-local` —
// `panic-local` vrací context-content, který by se v hodnotové pozici
// (přiřazení do proměnné) nikdy nevysázel, a chyba by se tiše spolkla.
#let normalize-trm-style(style) = {
  // Konstanty mají stejnou hodnotu jako svůj řetězec (singular == "singular" …),
  // takže stačí porovnat s konstantou; navíc povolíme aliasy "default" a kebab tvar.
  if style == none or style == singular or style == "default" {
    singular
  } else if style == plural {
    plural
  } else if style == first {
    first
  } else if style == first-plural or style == "first-plural" {
    first-plural
  } else {
    panic(
      "Neznámý styl / unknown style `" + str(style)
        + "`. Použijte / use `singular`, `plural`, `first`, `first_plural`.",
    )
  }
}

#let normalize-trm-case(case) = {
  if type(case) == int and case >= 1 and case <= 7 {
    case
  } else {
    panic("Neznámý pád / unknown case `" + str(case) + "`. Použijte číslo / use numbers 1-7.")
  }
}

// Čistý výběr zobrazovaného tvaru zkratky podle stylu (bez jakéhokoli stavu).
// `first`/`first_plural` vysází plný tvar „český (anglický - ZKRATKA)" —
// v textu se běžně nepoužívá (zavedení jsou psána ručně kvůli skloňování),
// ale zůstává jako explicitní API pro `style:`/`force:`.
#let acronym-display(fields, style, case) = {
  let short = str(fields.at("short", default: ""))
  let plural_field = fields.at("plural", default: none)
  let short_plural = if plural_field == none { short } else { str(plural_field) }
  if style == first {
    build-acronym-first-display(fields, short, grammatical_case: case)
  } else if style == first-plural {
    build-acronym-first-display(fields, short_plural, grammatical_case: case, plural_form: true)
  } else if style == plural {
    short_plural
  } else {
    short
  }
}

#let trm(key, style: singular, case: 1, force: none, display: none) = context {
  let requested_key = str(key)
  let resolved_style = normalize-trm-style(style)
  let resolved_case = normalize-trm-case(case)
  let force_first = force == true or force == first or force == "first"
  let effective_style = if force_first {
    if resolved_style == plural or resolved_style == first-plural { first-plural } else { first }
  } else { resolved_style }

  let acronyms = registry-definitions(acronyms-registry)
  let terms = registry-definitions(terms-registry)
  let acronym_key = find-key-or-short-case-insensitive(requested_key, acronyms)
  let term_key = find-key-or-short-case-insensitive(requested_key, terms)

  if acronym_key != none {
    // `display` zachová povrchový (skloňovaný) tvar z textu a jen ho prolinkuje.
    let body = if display != none { display } else {
      let fields = acronym-fields-from-value(acronym_key, acronyms.at(acronym_key))
      acronym-display(fields, effective_style, resolved_case)
    }
    link-to-acronym-entry(acronym_key, body)
  } else if term_key != none {
    // Pojem se v textu zobrazuje svým názvem (`short`), případně přes `display`
    // povrchovým tvarem — nutné pro víceslovné/skloňované pojmy.
    let body = if display != none { display } else {
      let value = terms.at(term_key)
      if type(value) == dictionary { str(value.at("short", default: term_key)) } else { str(term_key) }
    }
    link-to-term-entry(term_key, body)
  } else {
    let merged = (:)
    for (candidate, value) in acronyms { merged.insert(str(candidate), value) }
    for (candidate, value) in terms {
      if merged.at(str(candidate), default: none) == none { merged.insert(str(candidate), value) }
    }
    panic-unknown-key("pojem nebo zkratka", "term or acronym", requested_key, merged)
  }
}
