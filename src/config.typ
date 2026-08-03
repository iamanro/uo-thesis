// Načtení a normalizace typografické konfigurace z config.toml.
// Styly v src/styling/* importují hotový `cfg` (žádné opakované toml() ani
// parsování jednotek). Hodnoty upravuj v config.toml, ne zde.

#let raw = toml("config.toml")

// Převede řetězec s jednotkou na Typst délku/poměr: "12pt" → 12pt,
// "0.7em" → 0.7em, "47%" → 47%. Podporuje pt, mm, cm, in, em, %.
#let len(s) = {
  let units = ("pt": 1pt, "mm": 1mm, "cm": 1cm, "in": 1in, "em": 1em, "%": 1%)
  for (suffix, unit) in units {
    if s.ends-with(suffix) {
      return float(s.slice(0, s.len() - suffix.len()).trim()) * unit
    }
  }
  panic("config.toml: neznámá jednotka v hodnotě „" + s + "\" (povolené: pt, mm, cm, in, em, %)")
}

// Jako len(), ale řetězec "auto" propustí jako Typst `auto` (výchozí chování).
#let len-or-auto(s) = if s == "auto" { auto } else { len(s) }

// Typovaný config připravený k použití v sazbě.
#let cfg = (
  text: (
    font: raw.text.font,
    math-font: raw.text.math_font,
    raw-font: raw.text.raw_font,
    size: len(raw.text.size),
  ),
  par: (
    leading: len(raw.par.leading),
    indent: len(raw.par.first_line_indent),
    list-indent: len(raw.par.list_indent),
    list-spacing: len-or-auto(raw.par.list_spacing),
    enum-spacing: len-or-auto(raw.par.enum_spacing),
    spacing-min: len(raw.par.spacing_min),
    spacing-max: len(raw.par.spacing_max),
  ),
  link: (
    mono-color: rgb(raw.link.mono_color),
  ),
  page: (
    paper: raw.page.paper,
    margin-inside: len(raw.page.margin_inside),
    margin-outside: len(raw.page.margin_outside),
    margin-y: len(raw.page.margin_y),
    draft: (
      left: len(raw.page.draft.margin_left),
      right: len(raw.page.draft.margin_right),
      top: len(raw.page.draft.margin_top),
      bottom: len(raw.page.draft.margin_bottom),
    ),
  ),
  heading: (
    h1: len(raw.heading.h1_size),
    h1-gap: len(raw.heading.h1_gap),
    h2: len(raw.heading.h2_size),
    h3: len(raw.heading.h3_size),
    h4: len(raw.heading.h4_size),
    sub-gap: len(raw.heading.sub_gap),
  ),
  outline: (
    depth: raw.at("outline", default: (:)).at("depth", default: 3),
  ),
  table: (
    size: len(raw.table.size),
    inset-x: len(raw.table.inset_x),
    inset-y: len(raw.table.inset_y),
    rule-inner: len(raw.table.rule_inner),
    rule-outer: len(raw.table.rule_outer),
    caption-gap: len(raw.table.caption_gap),
  ),
  figure: (
    spacing: len(raw.figure.spacing),
    // Mezera popisku obrázků; když v [figure] chybí, převezme tabulkovou hodnotu.
    caption-gap: len(raw.figure.at("caption_gap", default: raw.table.caption_gap)),
  ),
  cover: (
    logo-height: len(raw.cover.logo_height),
    size-header: len(raw.cover.size_header),
    size-university: len(raw.cover.size_university),
    size-thesis-type: len(raw.cover.size_thesis_type),
    size-title: len(raw.cover.size_title),
    size-people: len(raw.cover.size_people),
    size-city-year: len(raw.cover.size_city_year),
    gap: len(raw.cover.gap),
    paragraph-leading: len(raw.cover.paragraph_leading),
    title-leading: len(raw.cover.title_leading),
  ),
  // Barvy fakult jako hotové Typst barvy.
  faculty: raw.faculty.pairs().map(((k, v)) => (k, rgb(v))).to-dict(),
)
