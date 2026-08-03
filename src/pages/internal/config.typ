#import "validation.typ": panic-bilingual
#import "people.typ": person

/// Normalizuje vstup. Pokud není slovník, vrátí prázdný.
#let _ensure-dict(value) = if type(value) == dictionary { value } else { (:) }

#let _validate-config-dict(value, error_key) = {
  if value != false and type(value) != dictionary {
    panic-bilingual(error_key)
  }
}

#let normalize-outlines(outlines) = {
  _validate-config-dict(outlines, "error_outlines_type")
  let cfg = _ensure-dict(outlines)
  (
    headings: cfg.at("headings", default: true),
    acronyms: cfg.at("acronyms", default: false),
    terms: cfg.at("terms", default: false),
    figures: cfg.at("figures", default: true),
    tables: cfg.at("tables", default: true),
    equations: cfg.at("equations", default: false),
    listings: cfg.at("listings", default: false),
    symbols: cfg.at("symbols", default: false),
  )
}

#let normalize-theme-config(theme) = {
  _validate-config-dict(theme, "error_theme_type")
  let cfg = _ensure-dict(theme)
  (
    color: cfg.at("color", default: false),
    links_colored: cfg.at("links_colored", default: true),
    faculty_colored: cfg.at("faculty_colored", default: true),
    faculty_color: cfg.at("faculty_color", default: none),
    link_color: cfg.at("link_color", default: none),
  )
}

#let metadata-or(label, fallback) = context {
  let items = query(label)
  if items.len() > 0 { items.last().value } else { fallback }
}

#let resolve-frontmatter(acknowledgement, introduction, abstract, keywords) = (
  acknowledgement: metadata-or(<unob-fm-acknowledgement>, acknowledgement),
  introduction: metadata-or(<unob-fm-introduction>, introduction),
  abstract: (
    czech: metadata-or(<unob-fm-abstract-cs>, abstract.czech),
    english: metadata-or(<unob-fm-abstract-en>, abstract.english),
  ),
  keywords: (
    czech: metadata-or(<unob-fm-keywords-cs>, keywords.czech),
    english: metadata-or(<unob-fm-keywords-en>, keywords.english),
  ),
)

// Klíče config.toml předávané šabloně beze změny (datové hodnoty).
#let _passthrough-keys = (
  "lang", "draft", "faculty", "programme", "specialisation", "thesis",
  "declaration", "ai_used", "keywords", "outlines", "theme",
  "docs", "submit_check", "vlna", "fancy_heading", "twoside",
)
// Klíče s osobami — obalí se přes person(), aby dostaly výchozí pole.
#let _person-keys = ("author", "supervisor", "first_advisor", "second_advisor")

// Funkce: thesis-config
// Co: Převede slovník z `toml("config.toml")` na pojmenované argumenty
//     `unob-thesis` (použití: `#show: unob-thesis.with(..thesis-config(...))`).
//     Osoby obalí přes `person(...)`; neznámý klíč (překlep) okamžitě ohlásí.
//     Obsahové parametry (abstract, introduction, bibliography, appendix, …)
//     v TOML být nemohou — předávají se dál přímo v main.typ.
#let thesis-config(data) = {
  if type(data) != dictionary {
    panic(
      "thesis-config očekává slovník z toml(\"config.toml\") / "
        + "thesis-config expects a dictionary from toml(\"config.toml\").",
    )
  }
  let result = (:)
  for (key, value) in data {
    if key in _person-keys {
      result.insert(key, person(..value))
    } else if key in _passthrough-keys {
      result.insert(key, value)
    } else {
      panic(
        "Neznámý klíč `" + key + "` v config.toml. Povolené klíče / allowed keys: "
          + (_person-keys + _passthrough-keys).join(", ") + ".",
      )
    }
  }
  result
}
