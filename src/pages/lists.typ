#import "internal/i18n/index.typ": t
#import "../styling/styles.typ": frontmatter-heading
#import "../config.typ": cfg
#import "internal/glossary/index.typ": (
  generate-acronyms-list, generate-symbols-list, generate-terms-list,
  has-used-acronyms, has-used-symbols, has-used-terms,
)

/// Vykreslí obsah a volitelné seznamy (zkratky, pojmy, obrázky, tabulky, rovnice, výpisy).
#let render-lists(
  outlines,
  glossary,
  lang: "cs",
) = {
  // Tisk čísel stran zapíná volající (render-final-layout) těsně před OBSAHEM.

  if outlines.headings != false {
    show outline.entry.where(level: 1): it => {
      set text(size: 14pt, weight: "bold")
      // Pozn.: `upper(it)` zvelčí i inline kód v položce (`let x = 1` →
      // `LET X = 1`), stejně jako u H1 v headings.typ. Opravit to jde jen
      // rozdělením přes it.indented(it.prefix(), upper-keep-raw(it.inner())),
      // jenže sama tahle rekonstrukce mění sazbu obsahu (jiné rozestupy
      // vodicích teček — odzkoušeno pixelově). Kód v nadpisu je vzácný,
      // takže to nestojí za změnu sazby všech položek obsahu.
      upper(it)
    }
    show outline.entry.where(level: 2): it => {
      set text(size: 13pt)
      it
    }
    show outline.entry.where(level: 3): it => {
      set text(size: 12pt, style: "italic")
      it
    }

    outline(
      // Musí odpovídat `supplement: [heading]` v src/styling/headings.typ —
      // při nesouladu se OBSAH tiše vykreslí PRÁZDNÝ (bez varování).
      target: heading.where(supplement: [heading], outlined: true),
      indent: 1em,
      depth: cfg.outline.depth,
      title: t("toc", lang: lang),
    )
  }

  // Zkratky a pojmy — seznamy vypisují všechny položky z glossary.toml
  // (glosář je kurátorovaný autorem; viz internal/glossary/registry.typ).
  context if outlines.acronyms != false and has-used-acronyms(glossary.acronyms) {
    frontmatter-heading(t("list_acronyms", lang: lang))
    generate-acronyms-list(glossary.acronyms)
  }

  context if outlines.terms != false and has-used-terms(glossary.terms) {
    frontmatter-heading(t("list_terms", lang: lang))
    generate-terms-list(glossary.terms)
  }

  context if outlines.at("symbols", default: false) != false and has-used-symbols(glossary.at("symbols", default: false)) {
    frontmatter-heading(t("list_symbols", lang: lang))
    generate-symbols-list(glossary.at("symbols", default: false))
  }

  // Zbývající seznamy se vykreslí jen při reálných položkách v dokumentu.
  let sections = (
    ("figures",   "list_figures",   figure.where(kind: image, outlined: true), false),
    ("tables",    "list_tables",    figure.where(kind: table, outlined: true), true),
    ("equations", "list_equations", math.equation,                         true),
    ("listings",  "list_listings",  figure.where(kind: raw, outlined: true),   true),
  )
  for (key, label, target, bookmarked) in sections {
    context if outlines.at(key) != false and query(target).len() > 0 {
      frontmatter-heading(t(label, lang: lang), bookmarked: bookmarked)
      outline(title: none, target: target)
    }
  }
}
