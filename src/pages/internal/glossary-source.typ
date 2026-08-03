// Funkce: resolve-glossary-source
// Co: Normalizuje vstupní zdroj glosáře, zkratek a pojmů.
#let resolve-glossary-source(value, default_file) = {
  if value == true {
    read(default_file)
  } else if value == false or value == none {
    false
  } else {
    value
  }
}

// Funkce: has-entries
// Co: Ověří, že hodnota je neprázdný slovník.
#let has-entries(value) = type(value) == dictionary and value.len() > 0
