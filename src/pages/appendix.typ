#import "internal/i18n/index.typ": t
#import "internal/utils.typ": has-value, is-draft-mode
#import "../styling/appendix.typ": (
  apply-appendix-content-styles, apply-appendix-outline-styles, has-appendix-headings,
  render-appendix-list-title,
)

/// Přepne sazbu do režimu příloh a vygeneruje seznam příloh.
#let appendix(show_outline: true, draft: auto, lang: "cs", twoside: true, body) = context {
  let is_draft = is-draft-mode(draft: draft)

  if not has-value(body) {
    []
  } else if is_draft {
    // Pravidlo: Draft zachová plynulý tok textu bez přepnutí sazby příloh.
    body
  } else {
    // SEZNAM PŘÍLOH patří ještě do hlavní číselné řady (a do hlavního OBSAHU),
    // proto se sází PŘED přepnutím sazby na přílohy — uvnitř by dostal
    // přílohové číslo „A–1", tedy totéž jako první příloha.
    if show_outline != false and has-appendix-headings(lang: lang) {
      render-appendix-list-title(lang: lang)
      // Pravidlo: Seznam příloh se skládá ručně, aby přílohové H1 nemusely být v hlavním obsahu.
      apply-appendix-outline-styles(lang: lang)
    }

    apply-appendix-content-styles(lang: lang, twoside: twoside)[#body]
  }
}
