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
