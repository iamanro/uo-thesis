// Vstup glosáře: převod `toml("glossary.toml")` na zkratky, pojmy a symboly
// a kontrola jejich integrity před sazbou.

// Šestice polí společných pro zkratky (short/en/cs/plural/longplural/csplural).
#let _acronym-fields(key, value) = (
  short: str(value.at("short", default: key)),
  en: value.at("en", default: none),
  cs: value.at("cs", default: none),
  plural: value.at("plural", default: none),
  longplural: value.at("longplural", default: none),
  csplural: value.at("csplural", default: none),
)

#let _entry(key, value) = {
  if type(value) != dictionary {
    // Přímý panic — `panic-local` by v hodnotové pozici vrátil content,
    // který se nevysází, a chyba by se maskovala pozdější typovou chybou.
    panic("Položka glosáře / glossary entry `" + key + "` musí být TOML tabulka / must be a TOML table.")
  }

  (
    key: key,
    .._acronym-fields(key, value),
    glossary: value.at("glossary", default: none),
    symbol: value.at("symbol", default: none),
    symbol_alt: value.at("symbol_alt", default: none),
    unit: value.at("unit", default: none),
    unit_alt: value.at("unit_alt", default: none),
  )
}

#let normalize-glossary-dictionary(document) = {
  if document.at("acronyms", default: none) != none or document.at("terms", default: none) != none or document.at("entries", default: none) != none {
    // Přímý panic (viz _entry) — jinak by se hláška spolkla do "cannot join".
    panic("Glosář používá jednotný formát / glossary uses the unified format: jedna TOML tabulka na položku / one TOML table per entry (`[iso]`, `[llm]`, ...).")
  }

  let result = (:)
  for (raw_key, value) in document {
    let key = str(raw_key)
    result.insert(key, _entry(key, value))
  }
  if result.len() == 0 { false } else { result }
}

#let normalize-glossary-input(input) = {
  if input == false or input == none {
    false
  } else if type(input) == dictionary {
    normalize-glossary-dictionary(input)
  } else {
    // Přímý panic (viz _entry) — v hodnotové pozici by se hláška spolkla.
    panic("Glosář předejte jako `toml(\"glossary.toml\")` / pass the glossary as `toml(\"glossary.toml\")`.")
  }
}

#let _entries-to-dict(entries, transform) = {
  if type(entries) != dictionary { return false }
  let result = (:)
  for (key, entry) in entries {
    let value = transform(str(key), entry)
    if value != none { result.insert(str(key), value) }
  }
  if result.len() == 0 { false } else { result }
}

// Zkratka = položka BEZ klíče `glossary`/`symbol` (i víceslovná, např. „MO ČR").
// Položka s klíčem `glossary` je pojem (viz `glossary-to-terms`), položka
// s klíčem `symbol` je symbol (viz `glossary-to-symbols`) — aby se žádná
// nezobrazovala ve více seznamech zároveň.
#let glossary-to-acronyms(entries) = _entries-to-dict(entries, (key, entry) => {
  if entry.at("glossary", default: none) == none and entry.at("symbol", default: none) == none {
    _acronym-fields(key, entry)
  }
})

#let glossary-to-terms(entries) = _entries-to-dict(entries, (key, entry) => {
  let glossary = entry.at("glossary", default: none)
  if glossary != none and entry.at("symbol", default: none) == none {
    (
      short: str(entry.at("short", default: key)),
      long: none,
      description: glossary,
      plural: entry.at("plural", default: none),
      longplural: entry.at("longplural", default: none),
    )
  }
})

// Symbol = položka s klíčem `symbol` (typeset ve math módu). Rozvedení nese
// `cs`/`en` (význam) a volitelně `unit` (jednotka). Symboly se do seznamu
// vypisují jako: symbol — (jednotka) — význam. Nejsou provázané přes `#trm`.
#let glossary-to-symbols(entries) = _entries-to-dict(entries, (key, entry) => {
  let symbol = entry.at("symbol", default: none)
  if symbol != none {
    (
      symbol: str(symbol),
      symbol_alt: entry.at("symbol_alt", default: none),
      unit: entry.at("unit", default: none),
      unit_alt: entry.at("unit_alt", default: none),
      cs: entry.at("cs", default: none),
      en: entry.at("en", default: none),
    )
  }
})

#let acronym-fields-from-value(key, value) = if type(value) == dictionary {
  _acronym-fields(key, value)
} else {
  (short: str(key), en: none, cs: none, plural: none, longplural: none, csplural: none)
}

// Funkce: panic-local
// Účel: Vyvolá chybu v jazyce dokumentu (`cs` / `en`).
#let panic-local(cs, en) = context {
  if text.lang == "en" { panic(en) } else { panic(cs) }
}

// Funkce: key-has-disallowed-chars
// Účel: Ověří, že klíč neobsahuje znaky, které komplikují vyhledávání.
#let key-has-disallowed-chars(key) = {
  (" ", ".", "/", "\\", ":", ";", ",", "\"", "'", "(", ")", "[", "]", "{", "}", "\t", "\n")
    .any(char => key.contains(char))
}

// Funkce: validate-case-insensitive-keys
// Účel: Ověří kolize klíčů při porovnání bez ohledu na velikost písmen.
#let validate-case-insensitive-keys(label_cs, label_en, definitions) = {
  let index = (:)
  for (raw_key, _) in definitions {
    let key = str(raw_key).trim()
    if key.len() == 0 {
      panic-local(
        "Klíč v `" + label_cs + "` nesmí být prázdný.",
        "Key in `" + label_en + "` must not be empty.",
      )
    }
    if key-has-disallowed-chars(key) {
      panic-local(
        "Klíč `" + key + "` v `" + label_cs
          + "` obsahuje nepovolené znaky. Použijte písmena/čísla/`_`/`-`.",
        "Key `" + key + "` in `" + label_en
          + "` contains unsupported characters. Use letters/digits/`_`/`-`.",
      )
    }

    let lookup = lower(key)
    let existing = index.at(lookup, default: ())
    index.insert(lookup, existing + (key,))
  }

  for (lookup, collisions) in index {
    if collisions.len() > 1 {
      panic-local(
        "Kolize klíčů v `" + label_cs + "` (case-insensitive): "
          + collisions.join(", "),
        "Case-insensitive key collision in `" + label_en + "`: "
          + collisions.join(", "),
      )
    }
  }
}

// Funkce: validate-short-duplicates
// Účel: Ověří duplicitní hodnoty `short` mezi zkratkami a pojmy.
#let validate-short-duplicates(acronyms, terms) = {
  let short_index = (:)

  for (raw_key, value) in acronyms {
    let key = str(raw_key)
    let short_value = if type(value) == dictionary {
      value.at("short", default: key)
    } else {
      key
    }
    let short = lower(str(short_value))
    let owner = "acronyms:" + key
    let existing = short_index.at(short, default: ())
    short_index.insert(short, existing + (owner,))
  }

  for (raw_key, value) in terms {
    let key = str(raw_key)
    let short = if type(value) == dictionary {
      lower(str(value.at("short", default: key)))
    } else {
      lower(key)
    }
    let owner = "terms:" + key
    let existing = short_index.at(short, default: ())
    short_index.insert(short, existing + (owner,))
  }

  for (short, owners) in short_index {
    if owners.len() > 1 {
      let source_keys = owners
        .map(owner => {
          let parts = owner.split(":")
          if parts.len() > 1 { parts.at(1) } else { owner }
        })
      let unique_sources = source_keys.dedup()

      // Pravidlo: Stejný `short` je povolen, pokud jde o tentýž zdrojový klíč
      // napříč reprezentací jedné položky jako zkratky i pojmu.
      if unique_sources.len() > 1 {
        panic-local(
          "Duplicitní `short` `" + short + "`: " + owners.join(", "),
          "Duplicate `short` `" + short + "`: " + owners.join(", "),
        )
      }
    }
  }
}

// Funkce: validate-optional-string-fields
// Účel: Ověří, že volitelná pole `plural`/`csplural`/`longplural`, pokud jsou
// přítomná, jsou neprázdný `str` (jinak selžou později a neintuitivně).
#let validate-optional-string-fields(label_cs, label_en, definitions) = {
  for (raw_key, value) in definitions {
    if type(value) != dictionary { continue }
    let key = str(raw_key)
    for field in ("plural", "csplural", "longplural") {
      let field_value = value.at(field, default: none)
      if field_value == none { continue }
      if type(field_value) != str or field_value.trim().len() == 0 {
        panic-local(
          "Pole `" + field + "` položky `" + key + "` v `" + label_cs
            + "` musí být neprázdný řetězec (`str`).",
          "Field `" + field + "` of entry `" + key + "` in `" + label_en
            + "` must be a non-empty string (`str`).",
        )
      }
    }
  }
}

// Funkce: validate-explanation-present
// Účel: Ověří, že položka má alespoň jedno rozvedení (`cs` / `en`) nebo
// definici (`glossary`). Jinak by v seznamu vznikl řádek se zkratkou a prázdnou
// pravou částí bez jakéhokoli upozornění.
#let validate-explanation-present(acronyms) = {
  for (raw_key, value) in acronyms {
    if type(value) != dictionary { continue }
    let key = str(raw_key)
    if value.at("cs", default: none) == none and value.at("en", default: none) == none {
      panic-local(
        "Položka `" + key + "` musí mít alespoň jedno z `cs` / `en` / `glossary`.",
        "Entry `" + key + "` must have at least one of `cs` / `en` / `glossary`.",
      )
    }
  }
}

// Funkce: validate-symbols
// Účel: Ověří, že každý symbol má typeset symbol i alespoň jeden význam (`cs`/`en`).
#let validate-symbols(symbols) = {
  for (raw_key, value) in symbols {
    if type(value) != dictionary { continue }
    let key = str(raw_key)
    if value.at("symbol", default: none) == none {
      panic-local(
        "Symbol `" + key + "` musí mít pole `symbol`.",
        "Symbol `" + key + "` must have a `symbol` field.",
      )
    }
    if value.at("cs", default: none) == none and value.at("en", default: none) == none {
      panic-local(
        "Symbol `" + key + "` musí mít alespoň jedno z `cs` / `en` (význam).",
        "Symbol `" + key + "` must have at least one of `cs` / `en` (meaning).",
      )
    }
  }
}

// Funkce: validate-glossary-registry
// Účel: Ověří integritu registru zkratek, pojmů a symbolů před sazbou.
#let validate-glossary-registry(acronyms, terms, symbols: false) = {
  let safe_acronyms = if type(acronyms) == dictionary { acronyms } else { (:) }
  let safe_terms = if type(terms) == dictionary { terms } else { (:) }
  let safe_symbols = if type(symbols) == dictionary { symbols } else { (:) }

  validate-case-insensitive-keys("zkratky", "acronyms", safe_acronyms)
  validate-case-insensitive-keys("pojmy", "terms", safe_terms)
  validate-optional-string-fields("zkratky", "acronyms", safe_acronyms)
  validate-optional-string-fields("pojmy", "terms", safe_terms)
  validate-explanation-present(safe_acronyms)
  validate-short-duplicates(safe_acronyms, safe_terms)
  validate-symbols(safe_symbols)
}
