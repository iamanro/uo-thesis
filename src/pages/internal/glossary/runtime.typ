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
#import "parse.typ": acronym-fields-from-value, panic-local
#import "declension.typ": build-acronym-first-display

// Návěští položek v SEZNAMU ZKRATEK / POJMŮ, na která `#trm` odkazuje.
#let acronym-label-prefix = "__unob_acronym_list_"
#let term-label-prefix = "__unob_term_list_"

// Registry slouží POUZE jako kanál pro předání definic z konfigurace šablony
// do `#trm` (modulová funkce nevidí data z main.typ lexikálně). Zapisují se
// právě jednou v `init-glossary-runtime` před sazbou obsahu a nikdy se nemění
// — každé čtení `.get()` je proto ve všech iteracích sazby stejné a nezávisí
// na stránkování (konvergenčně bezpečné).
// Indexy vznikají jednou spolu s definicemi, ne při každém #trm.
// Uchováváme všechny shody v pořadí definic kvůli diagnostice nejednoznačnosti.
#let index-definitions(definitions) = {
  let keys = (:)
  let shorts = (:)
  for (key, value) in definitions {
    let folded = lower(key)
    keys.insert(folded, keys.at(folded, default: ()) + (key,))
    if type(value) == dictionary {
      let short = value.at("short", default: none)
      if short != none {
        let folded-short = lower(str(short))
        shorts.insert(folded-short, shorts.at(folded-short, default: ()) + (key,))
      }
    }
  }
  (definitions: definitions, keys: keys, shorts: shorts)
}

#let acronyms-registry = state("unob-acronyms-registry", index-definitions((:)))
#let terms-registry = state("unob-terms-registry", index-definitions((:)))

#let init-glossary-runtime(acronyms, terms: false) = {
  let safe_acronyms = if type(acronyms) == dictionary { acronyms } else { (:) }
  let safe_terms = if type(terms) == dictionary { terms } else { (:) }

  acronyms-registry.update(index-definitions(safe_acronyms))
  terms-registry.update(index-definitions(safe_terms))
}

#let get-dictionary-keys(definitions) = {
  let keys = (:)
  for (raw_key, value) in definitions {
    let key = str(raw_key)
    keys.insert(lower(key), key)
    if type(value) == dictionary {
      let short = value.at("short", default: none)
      if short != none { keys.insert(lower(str(short)), str(short)) }
    }
  }
  keys.values().sorted(key: item => lower(item))
}

#let find-key-or-short-case-insensitive(raw_key, registry) = {
  let key = str(raw_key)
  // Přesný klíč má přednost před klíčem bez rozlišení velikosti i před short.
  if registry.definitions.at(key, default: none) != none { return key }
  let lookup = lower(key)
  let matches = registry.keys.at(lookup, default: ())
  if matches.len() == 1 { return matches.first() }
  if matches.len() > 1 {
    return panic-local(
      "Nejednoznačný klíč `" + key + "`. Odpovídá více položek: " + matches.join(", "),
      "Ambiguous key `" + key + "`. Multiple entries match: " + matches.join(", "),
    )
  }
  let matches = registry.shorts.at(lookup, default: ())
  if matches.len() == 1 { matches.first() }
  else if matches.len() > 1 {
    panic-local(
      "Nejednoznačný klíč `" + key + "`. Odpovídá více položek (podle `short`): " + matches.join(", "),
      "Ambiguous key `" + key + "`. Multiple entries match (by `short`): " + matches.join(", "),
    )
  } else { none }
}

#let panic-unknown-key(kind_cs, kind_en, key, definitions, unknown_cs: "Neznámý", unknown_en: "Unknown") = context {
  let keys = get-dictionary-keys(definitions)
  let prefix_matches = keys.filter(candidate => lower(candidate).starts-with(lower(key)))
  if text.lang == "en" {
    if prefix_matches.len() > 0 {
      panic(unknown_en + " " + kind_en + " `" + key + "`. Possible entries starting with `" + key + "`: " + prefix_matches.join(", "))
    } else if keys.len() > 0 {
      panic(unknown_en + " " + kind_en + " `" + key + "`. Available entries: " + keys.join(", "))
    } else {
      panic(unknown_en + " " + kind_en + " `" + key + "`. The list is empty.")
    }
  } else {
    if prefix_matches.len() > 0 {
      panic(unknown_cs + " " + kind_cs + " `" + key + "`. Možné položky začínající na `" + key + "`: " + prefix_matches.join(", "))
    } else if keys.len() > 0 {
      panic(unknown_cs + " " + kind_cs + " `" + key + "`. Dostupné položky: " + keys.join(", "))
    } else {
      panic(unknown_cs + " " + kind_cs + " `" + key + "`. Seznam je prázdný.")
    }
  }
}

#let link-to-acronym-entry(key, text) = context {
  let target = label(acronym-label-prefix + str(key))
  if query(selector(target)).len() > 0 { link(target, text) } else { text }
}

#let link-to-term-entry(key, text) = context {
  let target = label(term-label-prefix + str(key))
  if query(selector(target)).len() > 0 { link(target, text) } else { text }
}

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

  let acronym-registry = acronyms-registry.get()
  let term-registry = terms-registry.get()
  let acronym_key = find-key-or-short-case-insensitive(requested_key, acronym-registry)
  let term_key = find-key-or-short-case-insensitive(requested_key, term-registry)
  let acronyms = acronym-registry.definitions
  let terms = term-registry.definitions

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
