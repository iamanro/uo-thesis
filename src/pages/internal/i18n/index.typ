#import "./data.typ": base-faculty, translations, supported_faculties, supported_thesis_types, faculty_names, city_names, thesis_type_forms

#let active-language = state("unob-active-language", "cs")

#let supported_languages = ("cs", "en")

#let is-supported-language(lang) = lang in supported_languages

// Funkce: is-supported-faculty
// Účel: Ověří, zda je fakulta v podporovaném výčtu.
#let is-supported-faculty(faculty) = {
  faculty in supported_faculties
}

// Funkce: is-supported-thesis-type
// Účel: Ověří, zda je typ práce podporovaný.
#let is-supported-thesis-type(thesis_type) = {
  lower(str(thesis_type)) in supported_thesis_types
}

// Funkce: resolve-lang
// Účel: Normalizuje explicitní jazykový parametr na podporovaný kód.
#let resolve-lang(lang: auto) = {
  if lang == auto {
    "cs"
  } else if is-supported-language(lang) {
    lang
  } else if lang == "cz" {
    panic("Unsupported language `cz`. Use `cs` or `en`.")
  } else {
    panic("Unsupported language `" + str(lang) + "`. Use `cs` or `en`.")
  }
}

// Funkce: setup-language
// Účel: Nastaví jazyk textu i interní i18n stav šablony.
#let setup-language(body, lang: "cs") = {
  let loc = resolve-lang(lang: lang)
  active-language.update(loc)
  set text(lang: loc)
  body
}

// Funkce: current-lang
// Účel: Vrátí aktivní jazyk šablony v kontextu sazby.
#let current-lang() = {
  let configured = active-language.get()
  if configured == "en" or text.lang == "en" { "en" } else { "cs" }
}

#let with-lang(lang, body) = {
  if lang == auto {
    context body(current-lang())
  } else {
    body(resolve-lang(lang: lang))
  }
}

#let variant-at(items, variant, error-key, loc) = {
  if type(variant) == int and variant >= 1 and variant <= items.len() {
    items.at(variant - 1)
  } else {
    panic(t(error-key, lang: loc))
  }
}

#let translation-for(key, loc) = {
  let message = translations.at(key, default: none)
  if message == none {
    if loc == "en" {
      panic("Missing translation key: " + key)
    } else {
      panic("Chybí překladový klíč: " + key)
    }
  }
  if type(message) == dictionary {
    message.at(loc, default: message.at("cs", default: none))
  } else {
    message
  }
}

// Funkce: t
// Účel: Vrátí lokalizovaný text podle klíče.
#let t(key, lang: auto) = {
  with-lang(lang, loc => translation-for(key, loc))
}

// Funkce: faculty-name
// Účel: Vrátí název fakulty pro zadaný pád/variantu.
#let faculty-name(faculty, variant: 1, lang: auto) = {
  with-lang(lang, loc => {
    let entry = faculty_names.at(base-faculty(faculty), default: none)
    if entry == none {
      panic(t("error_unsupported_faculty", lang: loc))
    }

    variant-at(entry.at(loc), variant, "error_unsupported_faculty_variant", loc)
  })
}

// Funkce: city-name
// Účel: Vrátí název města fakulty pro zadanou variantu.
#let city-name(faculty, variant: 1, lang: auto) = {
  with-lang(lang, loc => {
    let entry = city_names.at(base-faculty(faculty), default: none)
    if entry == none {
      panic(t("error_unsupported_faculty", lang: loc))
    }

    variant-at(entry, variant, "error_unsupported_city_variant", loc)
  })
}

// Funkce: normalize-thesis-type
// Účel: Normalizuje typ práce na interní hodnotu.
#let normalize-thesis-type(thesis_type) = {
  if type(thesis_type) != str {
    panic(t("error_thesis_type_must_be_string"))
  }

  let candidate = lower(thesis_type)
  if not (candidate in supported_thesis_types) {
    panic(t("error_unsupported_thesis_type"))
  }
  candidate
}

// Funkce: thesis-type-name
// Účel: Vrátí lokalizovaný název typu práce pro zadaný tvar.
#let thesis-type-name(thesis_type, variant: 1, lang: auto) = {
  with-lang(lang, loc => {
    let normalized = normalize-thesis-type(thesis_type)
    let entry = thesis_type_forms.at(normalized, default: none)
    if entry == none {
      if loc == "en" {
        panic("Missing thesis type mapping for `" + normalized + "`.")
      } else {
        panic("Chybí mapování typu práce pro `" + normalized + "`.")
      }
    }

    variant-at(entry.at(loc), variant, "error_unsupported_thesis_type_variant", loc)
  })
}

// Funkce: thesis-type-is-bachelor-or-master
// Účel: Ověří, zda je typ práce bakalářský nebo magisterský.
#let thesis-type-is-bachelor-or-master(thesis_type) = {
  let normalized = normalize-thesis-type(thesis_type)
  normalized == "bachelor" or normalized == "master"
}

// Funkce: thesis-type-is-doctoral
// Účel: Ověří, zda je typ práce doktorský.
#let thesis-type-is-doctoral(thesis_type) = {
  normalize-thesis-type(thesis_type) == "doctoral"
}
