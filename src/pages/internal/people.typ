#import "utils.typ": has-person
#import "i18n/index.typ": t, current-lang

// Funkce: person
// Co: Vytvoří záznam osoby pro konfiguraci šablony.
// `genitive`: volitelný 2. pád celého jména ("Jana Nováka") pro čestné
// prohlášení. Pokud je `none`, použije se automatické skloňování. Nastavte
// ručně, pokud heuristika jméno skloní špatně.
#let person(
  prefix: "",
  name: "",
  surname: "",
  suffix: none,
  sex: none,
  genitive: none,
) = (
  prefix: prefix,
  name: name,
  surname: surname,
  suffix: suffix,
  sex: sex,
  genitive: genitive,
)

// Funkce: validate-person
// Účel: Ověří vstupy osoby vytvořené přes `person`. `role` je i18n klíč
//       popisující, o kterou osobu jde (autor / vedoucí / konzultant), aby
//       šla chyba dohledat. Nevyplněná osoba (`person()` bez jména/příjmení)
//       je legitimní placeholder (např. nevyužitý konzultant) a přeskočí se.
#let validate-person(person, role) = context {
  if has-person(person) {
    let loc = current-lang()
    let fail(key) = panic(t(role, lang: loc) + ": " + t(key, lang: loc))

    let name = person.at("name", default: none)
    if type(name) != str or name.trim().len() == 0 {
      fail("error_person_name_required")
    }
    let surname = person.at("surname", default: none)
    if type(surname) != str or surname.trim().len() == 0 {
      fail("error_person_surname_required")
    }
    let sex = person.at("sex", default: none)
    if sex != none and sex != "M" and sex != "F" {
      fail("error_person_sex")
    }
    for field in ("prefix", "suffix", "genitive") {
      let value = person.at(field, default: none)
      if value != none and type(value) != str {
        fail("error_person_" + field + "_type")
      }
    }
  }
}

// Funkce: format-name
// Co: Sestaví celé jméno osoby včetně titulů.
#let format-name(person) = [
  #person.prefix
  #person.name
  #if person.suffix != none {
    [#person.surname, #person.suffix]
  } else {
    [#person.surname]
  }
]

// Funkce: format-supervisor-for-declaration
// Co: Vrátí jméno vedoucího nebo školitele ve 2. pádě.
#let format-supervisor-for-declaration(supervisor) = {
  import "i18n/genitiv.typ": genitiv
  let override = supervisor.at("genitive", default: none)
  let name-in-genitive = if override != none {
    override
  } else {
    [#genitiv(supervisor.name) #genitiv(supervisor.surname)]
  }
  [
    #supervisor.prefix
    #name-in-genitive,
    #if supervisor.suffix != none {
      [#supervisor.suffix,]
    } else {
      []
    }
  ]
}
