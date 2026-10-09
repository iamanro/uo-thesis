// Sazba SEZNAMU ZKRATEK, POJMŮ a SYMBOLŮ.
#import "parse.typ": acronym-fields-from-value
#import "runtime.typ": acronym-label-prefix, term-label-prefix

// Seznamy vždy vypisují VŠECHNY položky z glossary.toml (glosář je kurátorovaný
// autorem — co v něm je, má být v seznamu). Dříve se filtrovalo podle stavových
// čítačů použití (`count-refs` z glossaria) a všechny položky se „registrovaly"
// skrytými #trm bloky v main.typ; obsah seznamů tak závisel na stavu, jehož
// hodnoty se měnily mezi iteracemi sazby → dokument nekonvergoval.
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
        symbol_alt: value.at("symbol_alt", default: none),
        unit: value.at("unit", default: none),
        unit_alt: value.at("unit_alt", default: none),
        cs: value.at("cs", default: none),
        en: value.at("en", default: none),
      ))
  }
}

#let has-glossary-value(value) = value != none and value != [] and (type(value) != str or value.trim().len() > 0)

#let generate-acronyms-list(acronyms) = {
  let entries = acronyms-to-glossary-entries(acronyms)
  if entries.len() > 0 {
    grid(
      columns: (auto, 1fr),
      column-gutter: 5mm,
      row-gutter: 5mm,
      ..entries.map(entry => {
        let short = str(entry.at("short", default: entry.at("key")))
        let key = str(entry.at("key", default: short))
        let long = entry.at("long", default: none)
        let description = entry.at("description", default: none)
        let meaning = if long != none { long } else { description }
        let translation = if long != none { description } else { none }
        // Menší řádkování uvnitř jednoho záznamu (mezera mezi originálem a
        // překladem) a `breakable: false`, aby se originál a překlad nikdy
        // nerozdělily přes zlom strany — celý záznam zůstane pohromadě.
        let explanation = if meaning == none {
          none
        } else {
          block(breakable: false, {
            set par(leading: 0.5em)
            if translation == none {
              meaning
            } else {
              stack(spacing: 2mm, meaning, translation)
            }
          })
        }
        if explanation == none { () } else { ([#strong(short)#label(acronym-label-prefix + key)], explanation) }
      }).flatten(),
    )
  }
}

// Vlastní sazba SEZNAMU POJMŮ. Pořadí je dané `terms-to-glossary-entries` (české řazení
// dle zobrazeného názvu, viz registry). Každý záznam nese návěští pro
// prolinkování z textu a je `breakable: false`, aby se nedělil přes zlom strany.
#let generate-terms-list(terms) = {
  let entries = terms-to-glossary-entries(terms)
  if entries.len() > 0 {
    for entry in entries {
      let short = str(entry.at("short", default: entry.at("key")))
      let key = str(entry.at("key", default: short))
      let description = entry.at("description", default: none)
      block(breakable: false, below: 5mm, {
        set par(leading: 0.5em, first-line-indent: 0pt)
        [#strong(short)#label(term-label-prefix + key): #description]
      })
    }
  }
}

// Vlastní sazba SEZNAMU SYMBOLŮ. Symbol se sází v matematickém režimu (`rho`,
// `v_max`, `nabla times bold(B)`). Jednotka se také sází matematicky, ale
// souvislé úseky písmen se obalí do textu, takže se vysází VZPŘÍMENĚ (správná
// typografie jednotek) a fungují mocniny: `kg m^(-3)`, `m s^(-1)`.
// Sloupce: symbol — jednotka — význam (český, případně s anglickým překladem).
#let generate-symbols-list(symbols) = {
  let entries = symbols-to-glossary-entries(symbols)
  if entries.len() > 0 {
    let as-math(s, alt) = math.equation(block: false, alt: alt, eval(str(s), mode: "math"))
    // Obalí písmenné úseky do uvozovek → v math módu vzpřímený text (jednotky).
    let quote-alpha(s) = {
      let out = ""
      let run = ""
      for c in str(s) {
        if lower(c) != upper(c) {
          run += c
        } else {
          if run.len() > 0 { out += "\"" + run + "\" " }
          run = ""
          out += c
        }
      }
      if run.len() > 0 { out += "\"" + run + "\"" }
      out
    }
    let as-unit(u, alt) = math.equation(block: false, alt: alt, eval(quote-alpha(u), mode: "math"))
    grid(
      columns: (auto, auto, 1fr),
      column-gutter: 5mm,
      row-gutter: 5mm,
      ..entries.map(entry => {
        let unit = entry.at("unit", default: none)
        let cs = entry.at("cs", default: none)
        let en = entry.at("en", default: none)
        let meaning = if has-glossary-value(cs) { cs } else { en }
        let translation = if has-glossary-value(cs) and has-glossary-value(en) { en } else { none }
        let explanation = block(breakable: false, {
          set par(leading: 0.5em)
          if translation == none { meaning } else { stack(spacing: 2mm, meaning, translation) }
        })
        (
          strong(as-math(entry.symbol, entry.symbol_alt)),
          if has-glossary-value(unit) { as-unit(unit, entry.unit_alt) } else { [] },
          explanation,
        )
      }).flatten(),
    )
  }
}
