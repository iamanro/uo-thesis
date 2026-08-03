/// Vrátí `true`, pokud je hodnota vyplněná (není `none`, `false`, `[]` ani prázdný string).
#let has-value(value) = {
  if value == none or value == false or value == [] {
    false
  } else if type(value) == str {
    value.trim().len() > 0
  } else {
    true
  }
}

/// Zjistí, zda je dokument v draft režimu.
/// Při `draft: auto` dotazuje metadata uzel `<unob-layout-draft>`; jinak použije předanou hodnotu.
/// Vyžaduje `context` (používá `query`).
#let is-draft-mode(draft: auto) = {
  if draft != auto {
    draft == true
  } else {
    let entries = query(<unob-layout-draft>)
    entries.len() > 0 and entries.first().value == true
  }
}

/// Vrátí `true`, pokud má osoba vyplněné alespoň jméno nebo příjmení.
/// Tolerantní k chybnému vstupu (např. `none` nebo neúplný slovník).
#let has-person(person) = {
  if type(person) != dictionary {
    false
  } else {
    has-value(person.at("name", default: none)) or has-value(person.at("surname", default: none))
  }
}
