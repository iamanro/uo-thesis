// Veřejné API šablony UNOB.
// Jediný soubor, který uživatel importuje ve svém main.typ.

#import "pages/unob-thesis.typ": unob-thesis
#import "pages/internal/people.typ": person
#import "pages/appendix.typ": appendix

// Načtení metadat práce z config.toml: unob-thesis.with(..thesis-config(toml("config.toml"))).
#import "pages/internal/config.typ": thesis-config

// Autorské pomůcky: TODO/poznámky viditelné jen v draftu, přepnutí na šířku
// a závěr práce (lokalizovaný nečíslovaný nadpis + obsah kapitoly).
#import "pages/internal/authoring.typ": conclusion, landscape, note, todo

// Flexibilní popisky figur (dlouhá verze pod figurou, krátká v seznamech).
#import "styling/flex-caption.typ": flex-caption

// Glosář — sazba zkratek, pojmů a jejich stylové konstanty.
#import "pages/internal/glossary/runtime.typ": first, first-plural, plural, singular, trm

// Nezlomitelné mezery („vlna") — šablona je aplikuje SAMA na celý dokument.
// NEimportuj @preview/vlna zvlášť: pravidla by se aplikovala dvakrát a
// kompilace se výrazně zpomalí (na 544stránkové práci +42 % času).
// Tyto přepínače slouží k vypnutí/zapnutí uprostřed textu.
#import "styling/packages.typ": vlna
#import vlna: *