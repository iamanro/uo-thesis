#set page(numbering: none)
#set text(size: 10pt)

= INTERNÍ DOKUMENTACE API

Tento dokument se zobrazí při `docs: true` v `#show: unob-thesis.with(...)`.

== Veřejný vstup

Hlavní veřejný vstup je `unob-thesis`. Konfigurace je inline v Typstu, bez externího konfiguračního souboru:

```typ
#show: unob-thesis.with(
  lang: "cs",
  draft: false,
  faculty: "fvt",
  thesis: (type: "master", title: "Název práce"),
  author: person(name: "Jan", surname: "Novák", sex: "M"),
  supervisor: person(name: "Jana", surname: "Nováková", sex: "F"),
  bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),
  appendix: [#include "appendix.typ"],
)
```

Kompletní seznam parametrů (včetně `symbols`, `vlna`, `fancy_heading`, `outlines`, `theme`, `submit_check`) je v README.

== Exporty z `lib.typ`

- `unob-thesis`: hlavní `#show` šablona.
- `person(...)`: osoba pro autora, vedoucího, školitele nebo konzultanta.
- `thesis-config(...)`: převod slovníku z `toml("config.toml")` na parametry šablony (`unob-thesis.with(..thesis-config(...))`); osoby obalí přes `person`, neznámý klíč ohlásí.
- `acknowledgement[...]`, `introduction[...]`, `abstract-cs[...]`, `abstract-en[...]`, `keywords-cs(...)`, `keywords-en(...)`, `conclusion[...]`: metadata helpery.
- `trm("key")`: jednotné API pro zkratky i pojmy.
- `singular`, `plural`, `first`, `first-plural`: styly pro `trm(...)`.
- `flex-caption(...)`: dvojí popisek figury (dlouhý pod objektem, krátký v seznamu).
- `todo[...]`, `note[...]`: autorské poznámky viditelné jen v draftu (`todo` blokuje `submit_check`).
- `landscape[...]`: otočí širokou tabulku/obrázek o 90° na stojaté straně (číslo strany zůstává v normální poloze).
- `vlna-on()`, `vlna-off()`, `vlna-debug-on()`, `vlna-debug-off()`: přepínání nezlomitelných mezer v části textu.
- `appendix[...]`: low-level režim příloh; běžně používejte parametr `appendix`.

== Glosář

Glosář používá jeden podporovaný TOML formát s jednou tabulkou na položku:

```toml
[iso]
short = "ISO"
en = "International Organization for Standardization"
cs = "Mezinárodní organizace pro standardizaci"
glossary = "Volitelný popis pojmu."
```

Parametry `acronyms: true` a `terms: true` načítají `template/glossary.toml`. V textu používejte jen `#trm("iso")`.

Symbol (Seznam symbolů) je položka s klíčem `symbol` (volitelně `unit`); zapíná se parametrem `symbols` a `outlines.symbols: true`:

```toml
[rho]
symbol = "rho"
unit = "kg m^(-3)"
cs = "hustota"
```

== Bibliografie a přílohy

Bibliografii předejte jako nativní Typst obsah:

```typ
bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true)
```

Přílohy předejte přes parametr `appendix`. Pokud přílohy neobsahují žádný H1 nadpis, nevykreslí se ani `SEZNAM PŘÍLOH`.

== Interní vrstvy

- `src/pages/*`: titulní strana, frontmatter, seznamy, přílohy a hlavní orchestrace.
- `src/pages/internal/*`: validace, metadata, osoby, lokalizace a glosář.
- `src/styling/*`: globální sazba, nadpisy, figury, přílohy a externí balíčky.
- `src/styling/vendor/*`: vendorizované moduly.
