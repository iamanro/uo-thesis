# UNOB — Šablona závěrečných prací

Oficiální šablona pro psaní bakalářských, diplomových a disertačních prací na Univerzitě obrany v sázecím systému [Typst](https://typst.app/). Šablona pokrývá všechny fakulty (`fvl`, `fvt`, `vlf`, `uo`) a dokáže sázet česky i anglicky.

*(English version below — [jump to English](#unob-thesis-template).)*

> **Návod má dvě části:** **[Základní použití](#základní-použití)** ti stačí k napsání celé práce. **[Pokročilé](#pokročilé)** je referenční příručka — čti ji, jen když budeš chtít něco navíc. Nemusíš mu rozumět, abys mohl začít.

## Základní použití

> Kompletní ukázková diplomová práce (citace, glosář, symboly, rovnice, tabulky,
> výpisy kódu, strana na šířku) je v [`examples/diplomka/`](examples/diplomka/):
> `typst compile --root . --font-path template/fonts examples/diplomka/main.typ`

### 1. Stažení šablony

Šablona je připravená k okamžité úpravě — nic se neinstaluje, píšeš rovnou v souboru `main.typ`. Stáhni si ji jedním ze dvou způsobů:

**Přes Git:**

```bash
git clone https://github.com/iamanro/unob-thesis.git
```

**Nebo ručně (bez Gitu):** otevři [stránku repozitáře](https://github.com/iamanro/unob-thesis), klikni na zelené tlačítko **Code ▸ Download ZIP** a stažený archiv rozbal.

### 2. Otevření a sazba

Práci píšeš v souboru **`main.typ`** v kořeni složky. Otevřít a průběžně sázet ho můžeš dvěma způsoby — vyber si jeden:

**Varianta A — VS Code + Tinymist (lokálně):**

1. Nainstaluj [VS Code](https://code.visualstudio.com/) a v něm z Marketplace rozšíření **Tinymist Typst**.
2. Ve VS Code zvol `File ▸ Open Folder…` a otevři složku `unob-thesis`.
3. Otevři `main.typ` a vpravo nahoře klikni na ikonu náhledu (**Preview**) — Typst sází živě, jak píšeš. (Kořen projektu se nastaví sám díky `.tinymist.toml`.)
4. Aby se použily přibalené fonty, nastav ve VS Code volbu `tinymist.fontPaths` na `template/fonts` (nebo si fonty nainstaluj systémově — viz [Fonty](#fonty)).
5. Hotové PDF vyexportuješ příkazem **Typst: Export to PDF** (`Ctrl/Cmd+Shift+P`).

**Varianta B — Typst Web App (v prohlížeči, bez instalace):**

1. Přihlaš se na [typst.app](https://typst.app/) a vytvoř nový prázdný projekt (**Empty project**).
2. Přetáhni do projektu **celý obsah** rozbalené složky — včetně `lib.typ`, `src/` a `template/` (i s fonty).
3. Otevři `main.typ`; sází se rovnou v prohlížeči a fonty se načtou automaticky.
4. Hotové PDF stáhneš tlačítkem **Download PDF**.

> Až bude šablona zveřejněná v [Typst Universe](https://typst.app/universe/), půjde projekt založit i jediným příkazem `typst init @preview/unob-thesis` — viz [Pokročilé](#pokročilé).

### 3. Příklad — `config.toml` a `main.typ`

Metadata práce vyplňuješ v souboru **`config.toml`**:

```toml
lang    = "cs"
faculty = "fvl"        # fvl | fvt | vlf | uo

[thesis]
type  = "master"       # bachelor | master | doctoral
title = "Název práce"

[author]
name    = "Jan"
surname = "Novák"
sex     = "M"

[supervisor]
name    = "Jana"
surname = "Nováková"
sex     = "F"

[keywords]
czech   = "první, druhé, třetí"
english = "first, second, third"
```

`main.typ` je pevná kostra — běžně ho neupravuješ (jen přidáš `#include` nové kapitoly). Konfiguraci načte a text vloží ze souborů:

```typ
#import "lib.typ": *

#let glossary = toml("glossary.toml")

#show: unob-thesis.with(
  ..thesis-config(toml("config.toml")),
  acronyms: glossary, terms: glossary, symbols: glossary,
  bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),
  appendix: [#include "appendix.typ"],
  // Výjimečné změny patří sem ZA spread — přepíšou hodnotu z config.toml.
)

#acknowledgement[#include "front/acknowledgement.typ"]
#abstract-cs[#include "front/abstract-cs.typ"]
#abstract-en[#include "front/abstract-en.typ"]
#introduction[#include "chapters/00-introduction.typ"]

#include "chapters/01-theory.typ"

#conclusion[#include "chapters/99-conclusion.typ"]
```

### 4. Jak ho vyplnit

- **Metadata** (fakulta, typ a název práce, osoby, klíčová slova, přepínače) vyplň v **`config.toml`** — každý klíč má komentář. Překlep v klíči šablona okamžitě ohlásí.
- **`sex`** (`"M"` / `"F"`) je potřeba, aby se správně skloňovaly tvary v čestném prohlášení.
- **Text práce** piš do souborů v `chapters/` — nadpisy kapitol přes `=`, podkapitoly přes `==`, `===`.
- **Zkratky, pojmy a symboly** dej do `glossary.toml`; v textu je vkládej přes `#trm("iso")`.
- **Zdroje (literaturu)** dej do `references.bib`; cituj přes `@klíč`.
- **Abstrakt a poděkování** piš do souborů ve `front/`.
- **Přílohy** piš do souboru `appendix.typ`.

To je vše, co potřebuješ k napsání práce. Další volby (barvy, více bibliografií, ruční skloňování, kontrola před odevzdáním…) najdeš níže v části **[Pokročilé](#pokročilé)**.

---

### 5. Struktura projektu

Metadata jsou v `config.toml`, próza v samostatných souborech vkládaných přes `#include`:

```
config.toml         metadata a přepínače práce
main.typ            načtení configu + obsahové části + #include kapitol
glossary.toml       zkratky, pojmy, symboly
references.bib      zdroje
front/              abstract-cs.typ, abstract-en.typ, acknowledgement.typ
chapters/           00-introduction.typ, 01-theory.typ, …, 99-conclusion.typ
appendix.typ        přílohy
```

Úvodní části se vkládají helpery (`#introduction[…]`, `#abstract-cs[…]`, …), závěr helperem `#conclusion[#include "chapters/99-conclusion.typ"]` na konci `main.typ`. V souborech kapitol importuj pomocné funkce **z balíčku** (`#import "@preview/unob-thesis:0.4.0": trm, flex-caption`), ne z `src/…`.

## Pokročilé

Referenční příručka pro pokročilejší úpravy. Pro běžné psaní ji nepotřebuješ.

### Konfigurace

Metadata práce se čtou z `config.toml` přes `thesis-config()` (`#show: unob-thesis.with(..thesis-config(toml("config.toml")), …)`). Všechny parametry lze zadat i inline přímo v `unob-thesis.with(...)` — inline hodnota uvedená za spreadem má přednost. Obsahové parametry (`abstract`, `introduction`, `bibliography`, `appendix`, …) se zadávají vždy v `main.typ`.

| Parametr | Typ / hodnoty | Výchozí | Popis |
|---|---|---|---|
| `lang` | `"cs"` \| `"en"` | `"cs"` | Jazyk dokumentu |
| `draft` | bool | `false` | Pracovní režim (viz [Draft a final](#draft-a-final)) |
| `faculty` | `"fvl"` \| `"fvt"` \| `"vlf"` \| `"uo"` \| `"uo-fvl"` \| `"uo-fvt"` \| `"uo-vlf"` | `"uo"` | Fakulta; varianty `uo-*` = fakulta s logem Univerzity obrany |
| `programme` | obsah / string | `[]` | Studijní program |
| `specialisation` | obsah / string | `[]` | Studijní specializace (u doktorského studia se popisek sází jako „Zaměření studia") |
| `thesis` | `(type, title)` | — | `type`: `"bachelor"` \| `"master"` \| `"doctoral"` |
| `author` | `person(...)` | — | Autor práce |
| `supervisor` | `person(...)` | — | Vedoucí / školitel |
| `first_advisor` | `person(...)` | prázdný | Odborný konzultant |
| `second_advisor` | `person(...)` | prázdný | Školitel-specialista (jen u disertace) |
| `assignment_front` | `none` \| obsah | `none` | Líc zadání — sken či export: png, jpg/jpeg i pdf, např. `image("zadani-1.pdf")` |
| `assignment_back` | `none` \| obsah | `none` | Rub zadání |
| `acknowledgement` | `false` \| obsah | `false` | Poděkování |
| `declaration` | bool | `true` | Čestné prohlášení |
| `ai_used` | bool | `false` | Prohlášení o použití AI |
| `acronyms` | `false` \| `true` \| slovník | `false` | Zkratky (viz [Glosář](#glosář)) |
| `terms` | `false` \| `true` \| slovník | `false` | Pojmy |
| `abstract` | `(czech, english)` | prázdné | Abstrakty |
| `keywords` | `(czech, english)` | prázdné | Klíčová slova |
| `introduction` | obsah | `[]` | Úvod (lze i přes `#introduction[...]`) |
| `outlines` | slovník | viz níže | Generované seznamy |
| `theme` | slovník | viz níže | Barevné přepínače |
| `bibliography` | `none` \| `bibliography(...)` \| pole | `none` | Bibliografie |
| `appendix` | `none` \| obsah | `none` | Přílohy |
| `docs` | bool | `false` | Zobrazí interní dokumentaci API (jen ve finálním režimu) |
| `submit_check` | bool | `false` | Přísná kontrola před odevzdáním |
| `symbols` | `false` \| slovník \| `true` | `false` | Symboly do Seznamu symbolů (viz `glossary.toml`) |
| `vlna` | bool \| `auto` | `auto` | Nezlomitelné mezery; `auto` = zapnuto ve final, vypnuto v draftu (rychlejší psaní) |
| `fancy_heading` | bool | `false` | Běžné („živé") záhlaví s názvem kapitoly |
| `twoside` | bool | `true` | Oboustranný tisk (kapitoly na liché straně, vakáty); `false` = elektronická verze bez prázdných stran |

`outlines` (každý klíč bool): `headings`, `acronyms`, `terms`, `symbols`, `figures`, `tables`, `equations`, `listings`.

`theme`: `color` (hlavní vypínač barev), `links_colored`, `faculty_colored`, `faculty_color` (vlastní barva nebo `none`), `link_color`.

`person(prefix, name, surname, suffix, sex, genitive)`: `sex` je `"M"`, `"F"` nebo `none` (pro `none` se použijí mužské tvary); `genitive` je volitelný ruční 2. pád celého jména pro čestné prohlášení.

### Veřejné API

Kořenový `lib.typ` exportuje:

- `unob-thesis`: hlavní šablona pro `#show`.
- `person(...)`: konfigurace autora, vedoucího a konzultantů.
- `thesis-config(...)`: převod slovníku z `toml("config.toml")` na parametry šablony (osoby obalí přes `person`, překlep v klíči ohlásí).
- `acknowledgement[...]`, `introduction[...]`, `abstract-cs[...]`, `abstract-en[...]`, `keywords-cs(...)`, `keywords-en(...)`, `conclusion[...]`: metadata helpery pro zadání úvodních částí přímo v textu.
- `trm("klic", style: ..., case: ...)`: vložení zkratky nebo pojmu z glosáře.
- `singular`, `plural`, `first`, `first-plural`: styly pro `trm(...)`.
- `appendix[...]`: low-level helper pro přílohy (běžně stačí parametr `appendix`).
- `flex-caption(...)`: dvojí popisek figury (dlouhý pod objektem, krátký v seznamech).
- `todo[...]`, `note[...]`: autorské poznámky viditelné jen v draftu (`todo` blokuje `submit_check`).
- `landscape[...]`: otočí širokou tabulku/obrázek o 90° na stojaté straně (číslo strany i záhlaví zůstávají v normální poloze); obsah se musí vejít na jednu stranu.
- `vlna-on()`, `vlna-off()`, `vlna-debug-on()`, `vlna-debug-off()`: přepínání nezlomitelných mezer v části textu.

### Glosář

Zkratky i pojmy jsou v jednom souboru `glossary.toml`, jedna TOML tabulka na položku:

```toml
[iso]
short = "ISO"
en = "International Organization for Standardization"
cs = "Mezinárodní organizace pro standardizaci"

[zero_trust]
short = "Zero Trust"
cs = "nulová důvěra"
glossary = "Bezpečnostní model, který implicitně nedůvěřuje žádnému prvku sítě."
```

- Položka **bez** klíče `glossary` je **zkratka** (SEZNAM ZKRATEK). `#trm` sází vždy krátký tvar — zkratku při prvním použití zaveď sám přes `style: first`. Krátký tvar (`short`) smí obsahovat mezeru (`MO ČR`).
- Položka **s** klíčem `glossary` je **pojem** (SEZNAM POJMŮ s definicí).

Pole: `short` (povinné), `en` a `cs` (rozvinutý tvar), `glossary` (definice). Volitelně `plural`, `longplural` (anglický plurál), `csplural` (český plurál).

Použij `acronyms: toml("glossary.toml")`, aby se promítly tvoje úpravy souboru. Hodnota `acronyms: true` načte vestavěný **demo** glosář z balíčku (hodí se jen pro první kompilaci).

V textu používej `#trm("iso")`. Pro množné číslo `#trm("iso", style: plural)`, pro první (rozvinuté) použití `#trm("iso", style: first)`. Parametr `case` (1–7) určuje český pád, např. `#trm("iso", case: 3)` (jen u zkratek). Seznamy zkratek, pojmů a symbolů vypisují všechny položky z `glossary.toml`, ať jsou v textu použité, nebo ne. Parametry `acronyms`, `terms` a `symbols` musí předat tentýž glosář.

### Bibliografie

Bibliografie je nativní Typst `bibliography(...)` předaná do konfigurace. Styl `iso-690-numeric` odpovídá ČSN ISO 690 a je vestavěný (nevyžaduje soubor CSL):

```typ
bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true)
```

Lze předat i pole a rozdělit zdroje do více seznamů s vlastními nadpisy, případně použít vlastní CSL:

```typ
bibliography: (
  bibliography("knihy.bib", style: "iso-690-numeric", full: true, title: [Knihy]),
  bibliography("online.bib", style: "iso-690-numeric", full: true, title: [Online zdroje]),
)
```

Pro vypnutí použij `bibliography: none`.

### Skloňování jména vedoucího

Čestné prohlášení je vždy v češtině a jméno vedoucího se skloňuje do 2. pádu automaticky. Pokud heuristika jméno skloní špatně, zadej správný tvar ručně:

```typ
supervisor: person(
  name: "Jan", surname: "Kadlec", sex: "M",
  genitive: "Jana Kadlece",
)
```

### Draft a final

Parametr `draft` přepíná režim. **Draft** je pro psaní — vypne titulní stranu a úvodní sazbu a zapne širší okraje. **Final** je odevzdávaná verze s kompletní titulní stranou, prohlášením, seznamy atd. Číslování stránek začíná od 1 na první číslované straně (OBSAH).

### Generované seznamy

Seznam obrázků, tabulek, rovnic a výpisů se vykreslí jen tehdy, když v dokumentu reálně existují odpovídající položky; seznam zkratek, pojmů a symbolů, když je glosář obsahuje — i když je příslušná volba v `outlines` nastavena na `true`.

### Přílohy

Přílohy se předávají jako obsah:

```typ
appendix: [#include "appendix.typ"]
```

Pokud přílohy neobsahují žádný H1 nadpis (`= Název přílohy`), nevykreslí se ani `SEZNAM PŘÍLOH`. Jednotlivé přílohy jsou v PDF záložkách, ale v hlavním obsahu je pouze `SEZNAM PŘÍLOH`.

### Fonty

Šablona používá rodinu **TeX Gyre**, která je přibalená ve složce `template/fonts/`:

- `TeX Gyre Termes` — hlavní text
- `TeX Gyre Termes Math` — matematická sazba
- `TeX Gyre Cursor` — kód a výpisy

Ve webové aplikaci se fonty načtou automaticky. Lokálně předej složku přes `--font-path template/fonts`, nebo si fonty nainstaluj systémově (pak `--font-path` není potřeba). Kompletní rodinu lze stáhnout z [CTAN](https://mirrors.ctan.org/fonts/tex-gyre.zip).

### Práce přímo s repozitářem

Pokud pracuješ přímo s tímto repozitářem, je k dispozici vývojový vzorek `main.typ` v kořeni (importuje lokální `lib.typ`) a [Taskfile](https://taskfile.dev/):

```bash
task build          # finální PDF do build/
task watch          # průběžná kompilace
task draft          # pracovní verze
task fonts          # seznam fontů
task clean          # úklid build/
task pdfa           # PDF/A-3b (archivace)
task pdfua          # PDF/UA-1 (přístupnost)
task archive        # PDF/A-3b + PDF/UA-1
```

### Výkon a regresní kontroly

Při lokální kompilaci velké práce vyzkoušej `--jobs 8` u `typst compile`
nebo `typst watch` místo automatického počtu vláken. Na měřeném 32vláknovém
Ryzen AI MAX+ PRO 395 byl nižší počet vláken rychlejší; nejde o univerzální
výchozí hodnotu. Porovnávej opakované běhy stejného dokumentu, se stejnými
fonty a zahřátou cache balíčků. Pro psaní používej `draft: true`; před
odevzdáním vždy ověř finální sazbu. Vypnutí vlny mění typografii, není to
bezeztrátová optimalizace.

Měření indexovaného glosáře a sjednocených importů (26. 9. 2026, Typst 0.15.1,
vlna 0.3.0, syntetická práce o 300 stranách, 200 definic a 2 152 odkazů glosáře):

| Vlákna | Před změnou, medián | Po změně, medián | Pokles času | Špičková RAM, medián |
| --- | ---: | ---: | ---: | ---: |
| 8 | 5,08 s | 4,89 s | 3,7 % | 766 → 736 MiB |
| 32 | 6,93 s | 6,78 s | 2,2 % | 771 → 741 MiB |

Sedm prokládaných párů na konfiguraci, zahřívací běhy nezapočteny; stejné fonty,
verze balíčků a čas vytvoření. Výsledné PDF bylo bajtově shodné. Jde o malé
zlepšení na sdílené pracovní stanici, nikoli záruku pro jiné práce. Odstavcový
wrapper zůstává: jeho odstranění mění stránkování u hranic stran.

Glosář při inicializaci vytváří indexy klíčů a krátkých názvů; `#trm` zachovává
přednost přesného klíče, pak klíče bez rozlišení velikosti a nakonec `short`.
Kontroly veřejného rozhraní (vyhledání, kolize, neznámé položky a odkazy podle
dostupnosti seznamů) spustíš z kořene repozitáře:

```bash
python3 -m unittest discover -s tests -v
```

Vyžadují Python 3, Typst a `pdftotext` (Poppler). Proměnná `TYPST` může určit
cestu ke konkrétní binárce. Testy sestavují skutečné PDF v dočasných adresářích
a po doběhnutí je odstraní.

### CI/CD na GitHubu

Workflow **Typst CI** (`.github/workflows/ci.yml`) běží pro pull requesty,
změny na `main` a ruční spuštění. Používá Ubuntu 24.04, verzi Typstu z
`package.compiler` v `typst.toml`, ověřený SHA-256 oficiální binárky a pouze
bundlované fonty. GitHub Actions jsou připnuté na konkrétní commity; CI má
jen právo číst repozitář a cache obsahuje pouze stažené Typst balíčky.

Kontroluje regresní testy glosáře i distribuce a **skutečnou instalaci přes
`typst init @local/…` z vytvořeného archivu**. Sestavuje sedm profilů šablony
(CS/EN, final/draft, všech sedm variant fakulty, jednostranná i oboustranná
sazba, živé záhlaví) a navíc exporty PDF/A-3b a PDF/UA-1. Varování kompilátoru
jsou chyba. Artefakt `typst-dist` se uchovává 14 dní: PDF, distribuční
`unob-thesis-<verze>.tar.gz`, `build-info.json` a `SHA256SUMS`.

Lokální ekvivalent (Python 3.12+, Git a Poppler; instalátor je pro Linux x86_64):

```bash
bash scripts/install-typst.sh /tmp/unob-typst
TYPST=/tmp/unob-typst/typst python3 scripts/ci.py check --output dist
(cd dist && sha256sum --check --strict SHA256SUMS)
```

Výstupní adresář musí být prázdný. Archiv obsahuje jen verzované soubory
`src/`, `template/` a vybrané kořenové soubory včetně licencí; nové soubory
před lokální kontrolou přidej pomocí `git add`. Při změně verze kompilátoru
aktualizuj také ověřený checksum v `scripts/install-typst.sh`.

**Vydání:** po změně `package.version` a odpovídajících importů šablony
vytvoř a pushni tag `v<package.version>`. Workflow **Typst release** znovu
provede celou kontrolu přes sdílený CI workflow; jiný tag odmítne. Teprve
poté job s `contents: write` ověří checksumy a založí GitHub Release s přesně
otestovanými artefakty. Existující vydání nepřepisuje. Není potřeba PAT ani
jiný vlastní secret; používá omezený `GITHUB_TOKEN`. Do Typst Universe se
nic automaticky nepublikuje.

PDF/UA vyžaduje u symbolů přirozený slovní popis `symbol_alt` a u jednotek
`unit_alt`, například `symbol_alt = "ró, hustota"` a
`unit_alt = "kilogram na metr krychlový"`. Šablona je předá do alternativního
textu matematických prvků; nevymýšlí popisy za autora. Úspěšný export Typstem
nenahrazuje nezávislé ověření přístupnosti (např. veraPDF a kontrolu čtečkou).

### Vzhled a typografie (`src/config.toml`)

Veškeré laditelné hodnoty sazby jsou na jednom místě v [`src/config.toml`](src/config.toml) — velikosti nadpisů (H1–H4), písma (text, matematika, kód), řádkování a odsazení odstavce, okraje stránky, sazba tabulek, titulní strana a barvy fakult. Styly v `src/styling/*` je čtou přes `src/config.typ`, takže úprava vzhledu nevyžaduje zásah do Typst kódu.

Délky se zapisují jako řetězec s jednotkou (`"12pt"`, `"0.7em"`, `"35mm"`, `"47%"`; jednotky `pt`, `mm`, `cm`, `in`, `em`, `%`). Například zvětšení nadpisů kapitol:

```toml
[heading]
h1_size = "16pt"
```

Sekce `[faculty]` obsahuje oficiální barvy fakult — neměň je bez svolení Univerzity obrany (viz `NOTICE`).

### Doporučené doplňkové balíčky

Šablona záměrně neexportuje vlastní boxy, callout bloky ani kreslicí nástroje. Pokud potřebuješ víc, použij balíčky z Typst Universe a importuj je přímo v práci (ne v jádru šablony): `@preview/showybox`, `@preview/frame-it`, `@preview/cetz`, `@preview/fletcher`, `@preview/physica`, `@preview/zero`, `@preview/subpar`.

> **NEimportuj `@preview/vlna`.** Nezlomitelné mezery řeší šablona sama na celém
> dokumentu (`@preview/vlna:0.3.0`, jediná verze určená v
> `src/styling/packages.typ`). Když balíček
> naimportuješ a zavoláš `#show: apply-vlna` ve svém `main.typ`, pravidla se
> aplikují **dvakrát** — výsledek je stejný, ale kompilace se výrazně zpomalí
> (měřeno na reálné 544stránkové disertaci: **7,9 s → 11,2 s wall, tj. +42 %**). Pro vypnutí vlny v části textu použij `#vlna-off()` / `#vlna-on()`,
> které šablona exportuje.

### Dobrá praxe a přístupnost

- Zkratky a pojmy drž v `glossary.toml` a používej je konzistentně.
- Preferuj vektorovou grafiku (`.svg`) a před odevzdáním optimalizuj větší obrázky.
- Před finálním odevzdáním vygeneruj final PDF a zkontroluj seznamy, reference i úvodní části.
- Pro přísnější validaci zapni `submit_check: true`.
- Nahraď veškerý ukázkový obsah (text, reference, glosář, metadata) vlastním.
- **Přístupnost (PDF/UA):** u vkládaných obrázků vždy doplň `alt` text — zejména u skenu zadání, např. `assignment_front: image("zadani.png", alt: "Zadání práce")`. Šablona sama nastavuje jazyk dokumentu, metadata (`title`, `author`, …) a `alt` u log; `alt` u vlastního obsahu musíš doplnit ty. Typst navíc ve výchozím stavu exportuje otagované (tagged) PDF, což je základ přístupnosti.
- **Symboly:** položky glosáře s klíčem `symbol` (a `unit`) se vysází do Seznamu symbolů (`symbols: ...`, `outlines.symbols: true`).
- **Autorské pomůcky:** `#todo[...]` a `#note[...]` jsou vidět jen v draftu; `#landscape[...]` otočí širokou tabulku/obrázek o 90° na stojaté straně. `submit_check: true` odmítne zbylá `#todo`.
- **Archivní/přístupné PDF:** `task pdfa` (PDF/A-3b) a `task pdfua` (PDF/UA-1), nebo `--pdf-standard a-3b,ua-1`. Před odevzdáním ověř shodu se standardem nástrojem [veraPDF](https://verapdf.org/) (profil PDF/A + PDF/UA se vybere automaticky podle metadat souboru).
- **Elektronická vs. tištěná verze:** pro odevzdávané elektronické PDF můžeš vypnout vakáty `twoside: false`; tištěná verze zůstává `twoside: true`.

### Licence

Zdrojový kód šablony je licencován pod **MIT** (viz `LICENSE`).

Loga fakult a univerzity (`src/assets/logo*.svg`) jsou duševním vlastnictvím Univerzity obrany a **nejsou** kryta licencí MIT — smí se použít pouze v rámci skutečné závěrečné práce na Univerzitě obrany a nesmí se upravovat (viz `NOTICE`). Přibalené fonty TeX Gyre podléhají GUST Font License (viz `template/fonts/LICENSE-FONTS.txt`). Ověř si, že použití log odpovídá pravidlům Univerzity obrany a tvé fakulty.

---

# UNOB Thesis Template

Official Typst template for writing bachelor's, master's, and doctoral theses at the University of Defence. It covers all faculties (`fvl`, `fvt`, `vlf`, `uo`) and typesets in Czech and English.

> **This guide has two parts:** **[Basic usage](#basic-usage)** is all you need to write your whole thesis. **[Advanced](#advanced)** is a reference — read it only when you want more. You don't need to understand it to get started.

## Basic usage

> A complete example thesis (citations, glossary, symbols, equations, tables,
> code listings, landscape page) lives in [`examples/diplomka/`](examples/diplomka/):
> `typst compile --root . --font-path template/fonts examples/diplomka/main.typ`

### 1. Download the template

The template is ready to edit right away — nothing to install, you write directly in `main.typ`. Get it in one of two ways:

**With Git:**

```bash
git clone https://github.com/iamanro/unob-thesis.git
```

**Or manually (no Git):** open the [repository page](https://github.com/iamanro/unob-thesis), click the green **Code ▸ Download ZIP** button, and unpack the archive.

### 2. Open and typeset

You write your thesis in **`main.typ`** in the root of the folder. There are two ways to open it and get a live preview — pick one:

**Option A — VS Code + Tinymist (locally):**

1. Install [VS Code](https://code.visualstudio.com/) and the **Tinymist Typst** extension from the Marketplace.
2. In VS Code choose `File ▸ Open Folder…` and open the `unob-thesis` folder.
3. Open `main.typ` and click the preview icon (**Preview**) in the top-right — Typst typesets live as you write. (The project root is set automatically via `.tinymist.toml`.)
4. To use the bundled fonts, set `tinymist.fontPaths` to `template/fonts` in the VS Code settings (or install the fonts system-wide — see [Fonts](#fonts)).
5. Export the finished PDF with the **Typst: Export to PDF** command (`Ctrl/Cmd+Shift+P`).

**Option B — Typst web app (in the browser, no install):**

1. Sign in at [typst.app](https://typst.app/) and create a new **Empty project**.
2. Drag the **entire contents** of the unpacked folder into the project — including `lib.typ`, `src/`, and `template/` (with the fonts).
3. Open `main.typ`; it typesets right in the browser and the fonts load automatically.
4. Download the finished PDF with the **Download PDF** button.

> Once the template is published on [Typst Universe](https://typst.app/universe/), you will also be able to create a project with a single command, `typst init @preview/unob-thesis` — see [Advanced](#advanced).

### 3. Example — `config.toml` and `main.typ`

Thesis metadata go into **`config.toml`**:

```toml
lang    = "en"
faculty = "fvl"        # fvl | fvt | vlf | uo

[thesis]
type  = "master"       # bachelor | master | doctoral
title = "Thesis Title"

[author]
name    = "Jan"
surname = "Novak"
sex     = "M"

[supervisor]
name    = "Jana"
surname = "Novakova"
sex     = "F"

[keywords]
czech   = "první, druhé, třetí"
english = "first, second, third"
```

`main.typ` is a fixed skeleton — you normally don't edit it (just add an `#include` for a new chapter). It loads the config and pulls text from files:

```typ
#import "lib.typ": *

#let glossary = toml("glossary.toml")

#show: unob-thesis.with(
  ..thesis-config(toml("config.toml")),
  acronyms: glossary, terms: glossary, symbols: glossary,
  bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),
  appendix: [#include "appendix.typ"],
  // Exceptional overrides go here AFTER the spread — they win over config.toml.
)

#acknowledgement[#include "front/acknowledgement.typ"]
#abstract-cs[#include "front/abstract-cs.typ"]
#abstract-en[#include "front/abstract-en.typ"]
#introduction[#include "chapters/00-introduction.typ"]

#include "chapters/01-theory.typ"

#conclusion[#include "chapters/99-conclusion.typ"]
```

### 4. How to fill it in

- **Metadata** (faculty, thesis type and title, people, keywords, switches) go in **`config.toml`** — every key is commented. A typo in a key is reported immediately.
- **`sex`** (`"M"` / `"F"`) is needed for correct Czech declension in the honour declaration.
- **Thesis text** goes into files in `chapters/` — chapter headings with `=`, subsections with `==`, `===`.
- **Acronyms, terms, and symbols** go in `glossary.toml`; insert them in text with `#trm("iso")`.
- **Sources** go in `references.bib`; cite with `@key`.
- **Abstract and acknowledgement** go into files in `front/`.
- **Appendices** go in `appendix.typ`.

That is everything you need to write your thesis. More options (colours, multiple bibliographies, manual declension, pre-submission checks…) are below under **[Advanced](#advanced)**.

---

### 5. Project structure

Metadata live in `config.toml`; prose lives in separate files pulled in via `#include`:

```
config.toml         thesis metadata and switches
main.typ            loads the config + content parts + #include of chapters
glossary.toml       acronyms, terms, symbols
references.bib      sources
front/              abstract-cs.typ, abstract-en.typ, acknowledgement.typ
chapters/           00-introduction.typ, 01-theory.typ, …, 99-conclusion.typ
appendix.typ        appendices
```

Frontmatter parts are inserted via helpers (`#introduction[…]`, `#abstract-cs[…]`, …), the conclusion via `#conclusion[#include "chapters/99-conclusion.typ"]` at the end of `main.typ`. In chapter files import helpers **from the package** (`#import "@preview/unob-thesis:0.4.0": trm, flex-caption`), not from `src/…`.

## Advanced

Reference for advanced tweaks. You don't need it for everyday writing.

### Configuration

Thesis metadata are read from `config.toml` via `thesis-config()` (`#show: unob-thesis.with(..thesis-config(toml("config.toml")), …)`). Every parameter can also be given inline directly in `unob-thesis.with(...)` — an inline value after the spread wins. Content parameters (`abstract`, `introduction`, `bibliography`, `appendix`, …) always go in `main.typ`.

| Parameter | Type / values | Default | Description |
|---|---|---|---|
| `lang` | `"cs"` \| `"en"` | `"cs"` | Document language |
| `draft` | bool | `false` | Draft mode (see [Draft and final](#draft-and-final)) |
| `faculty` | `"fvl"` \| `"fvt"` \| `"vlf"` \| `"uo"` \| `"uo-fvl"` \| `"uo-fvt"` \| `"uo-vlf"` | `"uo"` | Faculty; `uo-*` variants = faculty with the University of Defence logo |
| `programme` | content / string | `[]` | Study programme |
| `specialisation` | content / string | `[]` | Specialisation (for doctoral studies the label reads "Field of Study") |
| `thesis` | `(type, title)` | — | `type`: `"bachelor"` \| `"master"` \| `"doctoral"` |
| `author` | `person(...)` | — | Thesis author |
| `supervisor` | `person(...)` | — | Supervisor |
| `first_advisor` | `person(...)` | empty | Advisor |
| `second_advisor` | `person(...)` | empty | Co-supervisor (doctoral only) |
| `assignment_front` | `none` \| content | `none` | Assignment front — scan or export: png, jpg/jpeg, or pdf, e.g. `image("assignment-1.pdf")` |
| `assignment_back` | `none` \| content | `none` | Assignment back |
| `acknowledgement` | `false` \| content | `false` | Acknowledgement |
| `declaration` | bool | `true` | Honour declaration |
| `ai_used` | bool | `false` | AI-usage statement |
| `acronyms` | `false` \| `true` \| dict | `false` | Acronyms (see [Glossary](#glossary)) |
| `terms` | `false` \| `true` \| dict | `false` | Terms |
| `abstract` | `(czech, english)` | empty | Abstracts |
| `keywords` | `(czech, english)` | empty | Keywords |
| `introduction` | content | `[]` | Introduction (also via `#introduction[...]`) |
| `outlines` | dict | see below | Generated lists |
| `theme` | dict | see below | Colour switches |
| `bibliography` | `none` \| `bibliography(...)` \| array | `none` | Bibliography |
| `appendix` | `none` \| content | `none` | Appendices |
| `docs` | bool | `false` | Show the internal API documentation (final mode only) |
| `submit_check` | bool | `false` | Strict pre-submission validation |
| `symbols` | `false` \| dict \| `true` | `false` | Symbols for the List of Symbols (see `glossary.toml`) |
| `vlna` | bool \| `auto` | `auto` | Czech non-breaking spaces; `auto` = on in final, off in draft (faster writing loop) |
| `fancy_heading` | bool | `false` | Running header with the chapter title |
| `twoside` | bool | `true` | Two-sided printing (chapters on odd pages, blank versos); `false` = electronic version without blank pages |

`outlines` (each key bool): `headings`, `acronyms`, `terms`, `symbols`, `figures`, `tables`, `equations`, `listings`.

`theme`: `color` (master colour switch), `links_colored`, `faculty_colored`, `faculty_color` (custom colour or `none`), `link_color`.

`person(prefix, name, surname, suffix, sex, genitive)`: `sex` is `"M"`, `"F"`, or `none` (masculine forms are used for `none`); `genitive` is an optional manual genitive of the full name for the declaration.

### Public API

Root `lib.typ` exports:

- `unob-thesis`: the main `#show` template.
- `person(...)`: configuration of the author, supervisor, and advisors.
- `thesis-config(...)`: converts the dictionary from `toml("config.toml")` into template parameters (wraps people via `person`, reports key typos).
- `acknowledgement[...]`, `introduction[...]`, `abstract-cs[...]`, `abstract-en[...]`, `keywords-cs(...)`, `keywords-en(...)`, `conclusion[...]`: metadata helpers to set frontmatter sections inline in the text.
- `trm("key", style: ..., case: ...)`: inserts an acronym or glossary term.
- `singular`, `plural`, `first`, `first-plural`: styles for `trm(...)`.
- `appendix[...]`: low-level appendix helper (the `appendix` parameter is usually enough).
- `flex-caption(...)`: dual figure caption (long below the object, short in the lists).
- `todo[...]`, `note[...]`: authoring notes visible only in draft (`todo` blocks `submit_check`).
- `landscape[...]`: rotates a wide table/figure by 90° on a portrait page (page number and header stay upright); the content must fit a single page.
- `vlna-on()`, `vlna-off()`, `vlna-debug-on()`, `vlna-debug-off()`: toggle non-breaking spaces for part of the text.

### Glossary

Acronyms and terms live in a single `glossary.toml`, one TOML table per entry:

```toml
[iso]
short = "ISO"
en = "International Organization for Standardization"
cs = "Mezinárodní organizace pro standardizaci"

[zero_trust]
short = "Zero Trust"
cs = "nulová důvěra"
glossary = "A security model that implicitly trusts no element of the network."
```

- An entry **without** a `glossary` key is an **acronym** (LIST OF ACRONYMS). `#trm` always prints the short form — introduce the acronym yourself on first use with `style: first`. The short form (`short`) may contain a space (`MO ČR`).
- An entry **with** a `glossary` key is a **term** (LIST OF TERMS, with a definition).

Fields: `short` (required), `en` and `cs` (expansion), `glossary` (definition). Optionally `plural`, `longplural` (English plural), `csplural` (Czech plural).

Load the glossary with `acronyms: toml("glossary.toml")` so your edits to the file take effect. `acronyms: true` loads a built-in **demo** glossary from the package (useful only for the first compile).

In text use `#trm("iso")`. For plural `#trm("iso", style: plural)`, for the first (expanded) use `#trm("iso", style: first)`. The `case` parameter (1–7) selects the Czech grammatical case, e.g. `#trm("iso", case: 3)` (acronyms only). The lists of acronyms, terms and symbols print every entry in `glossary.toml`, used in the text or not. The `acronyms`, `terms` and `symbols` parameters must pass the same glossary.

### Bibliography

The bibliography is native Typst `bibliography(...)`. The `iso-690-numeric` style matches ČSN ISO 690 and is built in (no CSL file needed):

```typ
bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true)
```

You can also pass an array to split sources into several lists with their own titles, or use a custom CSL:

```typ
bibliography: (
  bibliography("books.bib", style: "iso-690-numeric", full: true, title: [Books]),
  bibliography("online.bib", style: "iso-690-numeric", full: true, title: [Online sources]),
)
```

Use `bibliography: none` to disable it.

### Declension of the supervisor's name

The honour declaration is always in Czech and the supervisor's name is automatically declined into the genitive. If the heuristic gets it wrong, supply the correct form manually via `person(..., genitive: "Jana Kadlece")`.

### Draft and final

The `draft` parameter switches modes. **Draft** is for writing — it disables the title page and frontmatter and enables wider margins. **Final** is the submitted version with the full title page, declaration, lists, etc. Page numbering starts at 1 on the first numbered page (table of contents).

### Generated lists

Lists of figures, tables, equations and listings render only when the document actually contains matching items; the lists of acronyms, terms and symbols render when the glossary has matching entries — even if the corresponding option in `outlines` is `true`.

### Appendices

Appendices are passed as content: `appendix: [#include "appendix.typ"]`. If the appendices contain no H1 heading (`= Appendix Title`), the `LIST OF APPENDICES` section is not rendered.

### Fonts

The template uses the **TeX Gyre** family, bundled in `template/fonts/`:

- `TeX Gyre Termes` — body text
- `TeX Gyre Termes Math` — mathematics
- `TeX Gyre Cursor` — code and listings

In the web app the fonts load automatically. Locally pass the folder via `--font-path template/fonts`, or install the fonts system-wide (then `--font-path` is not needed). The full family is available from [CTAN](https://mirrors.ctan.org/fonts/tex-gyre.zip).

### Working in this repository

When working directly in this repository there is a development sample `main.typ` in the root (it imports the local `lib.typ`) and a [Taskfile](https://taskfile.dev/): `task build`, `task watch`, `task draft`, `task fonts`, `task clean`, `task pdfa`, `task pdfua`, `task archive`.

### Performance and regression checks

For large local builds, try `--jobs 8` with `typst compile` or `typst watch`
instead of the automatic worker count. Fewer workers were faster on the
measured 32-thread Ryzen AI MAX+ PRO 395; this is not a universal default.
Compare repeated builds of the same document with identical fonts and warm
package caches. Use `draft: true` while writing and check final typesetting
before submission. Disabling vlna changes typography; it is not a lossless
optimization.

Indexed-glossary and centralized-import measurements (26 September 2026,
Typst 0.15.1, vlna 0.3.0, synthetic 300-page thesis with 200 definitions and
2,152 glossary references):

| Workers | Before, median | After, median | Elapsed reduction | Median peak RAM |
| --- | ---: | ---: | ---: | ---: |
| 8 | 5.08 s | 4.89 s | 3.7% | 766 → 736 MiB |
| 32 | 6.93 s | 6.78 s | 2.2% | 771 → 741 MiB |

Seven interleaved pairs per configuration, excluding warm-ups; identical fonts,
package versions, and creation timestamp. The resulting PDFs were byte-identical.
This is a modest improvement on a shared workstation, not a guarantee for other
theses. The paragraph wrapper remains: removing it changes pagination near page
boundaries.

The glossary builds key and short-name indexes during initialization. `#trm`
keeps exact-key precedence, followed by case-insensitive keys and then short
names. Run the public-interface checks for resolution, collisions, unknown
entries, and links with and without glossary lists from the repository root:

```bash
python3 -m unittest discover -s tests -v
```

These require Python 3, Typst, and `pdftotext` (Poppler). Set `TYPST` to select
a compiler binary. Tests compile real PDFs in temporary directories and
remove them afterward.

### GitHub CI/CD

**Typst CI** (`.github/workflows/ci.yml`) runs on pull requests, pushes to
`main`, and manual dispatch. It uses Ubuntu 24.04, the compiler version in
`typst.toml` (`package.compiler`), a SHA-256-verified official binary, and
bundled fonts only. Actions are commit-pinned; CI has read-only repository
permissions and caches only downloaded Typst packages.

It runs glossary and distribution regression tests, then **installs the built
archive using `typst init @local/…`**. Seven template profiles cover CS/EN,
final/draft, all seven faculty variants, single-/double-sided layout, and
running headers. Additional builds export PDF/A-3b and PDF/UA-1. Compiler
warnings fail the job. The `typst-dist` artifact is retained for 14 days and
contains PDFs, `unob-thesis-<version>.tar.gz`, `build-info.json`, and
`SHA256SUMS`.

Run the same checks locally (Python 3.12+, Git, and Poppler; installer targets
Linux x86_64):

```bash
bash scripts/install-typst.sh /tmp/unob-typst
TYPST=/tmp/unob-typst/typst python3 scripts/ci.py check --output dist
(cd dist && sha256sum --check --strict SHA256SUMS)
```

Use an empty output directory. Packaging includes only tracked `src/`,
`template/`, and selected root files, including licenses. Stage new files with
`git add` before local checks. When changing the compiler version, update its
verified archive checksum in `scripts/install-typst.sh` too.

**Releasing:** update `package.version` and the matching template imports,
then create and push `v<package.version>`. **Typst release** reruns the entire
shared CI workflow and rejects a mismatched tag. Only its publishing job has
`contents: write`: it verifies checksums and creates a GitHub Release from the
exact tested artifacts. Existing releases are not overwritten. No PAT or
custom secret is needed; it uses the scoped `GITHUB_TOKEN`. Nothing is
submitted automatically to Typst Universe.

For PDF/UA, author natural-language `symbol_alt` and `unit_alt` descriptions
for glossary symbols and units (see `template/glossary.toml`). The template
passes them to the math elements' alternative text; it does not invent
descriptions. Successful Typst export is not independent accessibility
certification; use tools such as veraPDF and assistive-technology review too.

### Recommended additional packages

The template intentionally does not export custom boxes, callout blocks, or drawing tools. If you need more, use packages from Typst Universe and import them directly in your thesis (not in the template core): `@preview/showybox`, `@preview/frame-it`, `@preview/cetz`, `@preview/fletcher`, `@preview/physica`, `@preview/zero`, `@preview/subpar`.

> **Do not import `@preview/vlna`.** The template applies Czech non-breaking
> spaces itself across the whole document (`@preview/vlna:0.3.0`, pinned only in
> `src/styling/packages.typ`). Importing the package and calling
> `#show: apply-vlna` in your `main.typ` applies every rule **twice** — the
> output is the same, but compilation gets markedly slower (measured on a real
> 544-page dissertation: **7.9 s → 11.2 s wall, i.e. +42 %**). To
> disable gluing for part of the text use `#vlna-off()` / `#vlna-on()`, which
> the template exports.

### Good practice and accessibility

- Keep acronyms and terms in `glossary.toml` and use them consistently.
- Prefer vector graphics (`.svg`) and optimize larger images before submission.
- Before final submission, generate the final PDF and check the lists, references, and frontmatter.
- Enable `submit_check: true` for stricter validation.
- Replace all sample content (text, references, glossary, metadata) with your own.
- **Accessibility (PDF/UA):** always add `alt` text to images you insert — especially a scanned assignment, e.g. `assignment_front: image("assignment.png", alt: "Thesis assignment")`. The template sets the document language, PDF metadata (`title`, `author`, …), and `alt` on the faculty logos for you; add `alt` to your own content. Typst also writes a tagged PDF by default, which is the baseline for accessibility.
- **Symbols:** glossary entries with a `symbol` field (and `unit`) are typeset into the List of Symbols (`symbols: ...`, `outlines.symbols: true`).
- **Authoring helpers:** `#todo[...]` and `#note[...]` show only in draft; `#landscape[...]` rotates a wide table/figure by 90° on a portrait page. `submit_check: true` rejects leftover `#todo`.
- **Archival/accessible PDF:** `task pdfa` (PDF/A-3b) and `task pdfua` (PDF/UA-1), or `--pdf-standard a-3b,ua-1`. Before submission, verify conformance with [veraPDF](https://verapdf.org/) (the PDF/A + PDF/UA profile is selected automatically from the file's metadata).
- **Electronic vs. printed version:** for the submitted electronic PDF you can disable blank versos with `twoside: false`; keep `twoside: true` for print.

### License

The template source code is licensed under **MIT** (see `LICENSE`).

The faculty and university logos (`src/assets/logo*.svg`) are the intellectual property of the University of Defence and are **not** covered by the MIT license — they may be used only as part of a genuine University of Defence thesis and must not be modified (see `NOTICE`). The bundled TeX Gyre fonts are subject to the GUST Font License (see `template/fonts/LICENSE-FONTS.txt`). Make sure the logo usage complies with the rules of the University of Defence and your faculty.
