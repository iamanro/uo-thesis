#import "./validate.typ": panic-local
#import "./registry.typ": acronym-label-prefix, term-label-prefix

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

#let find-key-case-insensitive(raw_key, definitions) = {
  let key = str(raw_key)
  if definitions.at(key, default: none) != none {
    key
  } else {
    let lookup = lower(key)
    let matches = definitions.pairs().map(((candidate, _)) => str(candidate)).filter(candidate => lower(candidate) == lookup)
    if matches.len() == 1 { matches.at(0) }
    else if matches.len() > 1 {
      panic-local(
        "Nejednoznačný klíč `" + key + "`. Odpovídá více položek: " + matches.join(", "),
        "Ambiguous key `" + key + "`. Multiple entries match: " + matches.join(", "),
      )
    } else { none }
  }
}

#let find-key-by-short-case-insensitive(raw_key, definitions) = {
  let lookup = lower(str(raw_key))
  let matches = definitions
    .pairs()
    .filter(((candidate, value)) => type(value) == dictionary and value.at("short", default: none) != none and lower(str(value.at("short"))) == lookup)
    .map(((candidate, _)) => str(candidate))
  if matches.len() == 1 { matches.at(0) }
  else if matches.len() > 1 {
    panic-local(
      "Nejednoznačný klíč `" + str(raw_key) + "`. Odpovídá více položek (podle `short`): " + matches.join(", "),
      "Ambiguous key `" + str(raw_key) + "`. Multiple entries match (by `short`): " + matches.join(", "),
    )
  } else { none }
}

#let find-key-or-short-case-insensitive(raw_key, definitions) = {
  let direct = find-key-case-insensitive(raw_key, definitions)
  if direct != none { direct } else { find-key-by-short-case-insensitive(raw_key, definitions) }
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
