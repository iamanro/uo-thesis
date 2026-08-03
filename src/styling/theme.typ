#import "../config.typ": cfg
#import "../pages/internal/i18n/data.typ": base-faculty

// Data: Cesty k logům fakult. Barvy fakult jsou v config.toml ([faculty]).
#let faculty-logos = (
  fvl: "../assets/logoFVL.svg",
  fvt: "../assets/logoFVT.svg",
  vlf: "../assets/logoVLF.svg",
  uo:  "../assets/logoUO.svg",
)

// Funkce: get-faculty-color
// Co: Vrátí barvu fakulty podle zkratky (z config.toml).
#let get-faculty-color(faculty) = {
  cfg.faculty.at(base-faculty(faculty), default: rgb("#000000"))
}

// Funkce: resolve-theme-color
// Co: Převede hex řetězec z konfigurace na Typst barvu.
/// Převede hex řetězec z konfigurace na Typst barvu; pokud je prázdný, vrátí fallback.
#let resolve-theme-color(value, fallback: none) = {
  if type(value) == str and value.trim().len() > 0 {
    rgb(value.trim())
  } else {
    fallback
  }
}

// Funkce: resolve-theme
// Co: Normalizuje uživatelské nastavení barev pro sazbu.
#let resolve-theme(theme, faculty) = (
  color: theme.at("color", default: false),
  links_colored: theme.at("color", default: false) and theme.at("links_colored", default: true),
  faculty_colored: theme.at("color", default: false) and theme.at("faculty_colored", default: true),
  faculty_color: resolve-theme-color(theme.at("faculty_color", default: none), fallback: get-faculty-color(faculty)),
  link_color: resolve-theme-color(theme.at("link_color", default: none), fallback: none),
)

// Funkce: get-logo-path
// Co: Sestaví cestu k logu fakulty pro `src/pages/cover.typ`.
#let get-logo-path(faculty) = {
  // Varianty `uo-*` mají logo Univerzity obrany; vše ostatní logo fakulty.
  let key = if str(faculty).starts-with("uo-") { "uo" } else { faculty }
  faculty-logos.at(key, default: "../assets/logo" + upper(key) + ".svg")
}
