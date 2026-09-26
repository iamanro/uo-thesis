#import "./parse.typ": acronym-fields-from-value

#let acronyms-group = "__acronyms"
#let terms-group = "__terms"
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

#let acronyms-to-glossary-entries(acronyms_dict) = {
  if type(acronyms_dict) != dictionary {
    ()
  } else {
    acronyms_dict
      .pairs()
      .sorted(key: ((key, value)) => str(value.at("short", default: str(key))).normalize(form: "nfd"))
      .map(((raw_key, value)) => {
        let key = str(raw_key)
        let fields = acronym-fields-from-value(key, value)
        let short = str(fields.at("short", default: key))
        let plural_raw = fields.at("plural", default: none)
        (
          key: key,
          short: short,
          long: fields.at("en", default: none),
          description: fields.at("cs", default: none),
          plural: if plural_raw != none { plural_raw } else { short },
          longplural: fields.at("longplural", default: none),
          group: acronyms-group,
        )
      })
  }
}

#let terms-to-glossary-entries(terms_dict) = {
  if type(terms_dict) != dictionary {
    ()
  } else {
    terms_dict
      .pairs()
      .sorted(key: ((key, value)) => str(value.at("short", default: str(key))).normalize(form: "nfd"))
      .map(((key, value)) => (
        key: str(key),
        short: value.at("short", default: str(key)),
        long: value.at("long", default: none),
        description: value.at("description", default: none),
        plural: value.at("plural", default: none),
        longplural: value.at("longplural", default: none),
        group: terms-group,
      ))
  }
}

#let symbols-to-glossary-entries(symbols_dict) = {
  if type(symbols_dict) != dictionary {
    ()
  } else {
    symbols_dict
      .pairs()
      .sorted(key: ((key, value)) => str(value.at("symbol", default: str(key))).normalize(form: "nfd"))
      .map(((key, value)) => (
        key: str(key),
        symbol: str(value.at("symbol", default: str(key))),
        unit: value.at("unit", default: none),
        cs: value.at("cs", default: none),
        en: value.at("en", default: none),
      ))
  }
}

// Seznamy vždy vypisují VŠECHNY položky z glossary.toml (glosář je kurátorovaný
// autorem — co v něm je, má být v seznamu). Dříve se filtrovalo podle stavových
// čítačů použití (`count-refs` z glossaria) a všechny položky se „registrovaly"
// skrytými #trm bloky v main.typ; obsah seznamů tak závisel na stavu, jehož
// hodnoty se měnily mezi iteracemi sazby → dokument nekonvergoval.
#let get-acronym-entries(acronyms) = acronyms-to-glossary-entries(acronyms)
#let get-term-entries(terms) = terms-to-glossary-entries(terms)
#let has-used-acronyms(acronyms) = get-acronym-entries(acronyms).len() > 0
#let has-used-terms(terms) = get-term-entries(terms).len() > 0
#let get-symbol-entries(symbols) = symbols-to-glossary-entries(symbols)
#let has-used-symbols(symbols) = get-symbol-entries(symbols).len() > 0

#let init-glossary-runtime(acronyms, terms: false) = {
  let safe_acronyms = if type(acronyms) == dictionary { acronyms } else { (:) }
  let safe_terms = if type(terms) == dictionary { terms } else { (:) }

  acronyms-registry.update(index-definitions(safe_acronyms))
  terms-registry.update(index-definitions(safe_terms))
}
