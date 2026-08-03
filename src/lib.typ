// Veřejné API šablony UNOB.
// Jediný soubor, který uživatel importuje ve svém main.typ.

#import "pages/unob-thesis.typ": unob-thesis
#import "pages/internal/people.typ": person
#import "pages/appendix.typ": appendix

// Načtení metadat práce z config.toml: unob-thesis.with(..thesis-config(toml("config.toml"))).
#import "pages/internal/config.typ": thesis-config

// Autorské pomůcky: TODO/poznámky viditelné jen v draftu a přepnutí na šířku.
#import "pages/internal/authoring.typ": landscape, note, todo

// Flexibilní popisky figur (dlouhá verze pod figurou, krátká v seznamech).
#import "styling/flex-caption.typ": flex-caption

// Glosář — sazba zkratek, pojmů a jejich stylové konstanty.
#import "pages/internal/glossary/index.typ": first, first-plural, plural, singular, trm

// Sekce práce — vloží metadata pro úvod, závěr, abstrakt, klíčová slova.
#import "pages/internal/metadata.typ": (
  abstract-cs, abstract-en, acknowledgement, conclusion, introduction, keywords-cs, keywords-en,
)

// Nezlomitelné mezery („vlna") — šablona je aplikuje SAMA na celý dokument.
// NEimportuj @preview/vlna zvlášť: pravidla by se aplikovala dvakrát a
// kompilace se výrazně zpomalí (na 544stránkové práci +42 % času).
// Tyto přepínače slouží k vypnutí/zapnutí uprostřed textu.
#import "@preview/vlna:0.3.0": *