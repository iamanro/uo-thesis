<div align="center">

# UNOB — šablona závěrečných prací

**Oficiální šablona pro bakalářské, diplomové a disertační práce na Univerzitě obrany v&nbsp;[Typstu](https://typst.app/).**<br>
Všechny fakulty · česky i anglicky · PDF/A a PDF/UA · sazba pod sekundu

[![CI](https://github.com/iamanro/uo-thesis/actions/workflows/ci.yml/badge.svg)](https://github.com/iamanro/uo-thesis/actions/workflows/ci.yml) [![Verze](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fiamanro%2Fuo-thesis%2Fmain%2Ftypst.toml&query=%24.package.version&label=verze&color=808205)](CHANGELOG.md) [![Typst](https://img.shields.io/badge/dynamic/toml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fiamanro%2Fuo-thesis%2Fmain%2Ftypst.toml&query=%24.package.compiler&label=typst&color=239dad&logo=typst&logoColor=white)](https://typst.app/) [![Licence](https://img.shields.io/badge/licence-AGPL--3.0-6188cd)](LICENSE)

**Česky** · [English](README.en.md)

<img src=".github/assets/hero.webp" alt="Ukázka vysázené práce: titulní strana, obsah, seznam zkratek a kapitola s tabulkou, rovnicí a výpisem kódu" width="100%">

[Rychlý start](#rychlý-start) · [Psaní práce](#psaní-práce) · [Reference](#reference) · [Vývoj](#vývoj) · [Licence](#licence)

</div>

---

## Co šablona umí

- 🏛️ **Všechny fakulty a typy prací** — `fvl`, `fvt`, `vlf`, `uo` i varianty s logem Univerzity obrany; bakalářská, diplomová i disertační práce.
- 🌍 **Česky i anglicky** — titulní strana, nadpisy a seznamy se přeloží samy; čestné prohlášení je vždy česky a jméno vedoucího se skloní do 2. pádu.
- ⚙️ **Vše v jednom `config.toml`** — metadata a přepínače na jednom místě, překlep v klíči šablona hned ohlásí.
- 📚 **Glosář, symboly, citace** — `#trm` pro zkratky a pojmy s českými pády, seznam symbolů s jednotkami, ČSN ISO 690.
- ✅ **Kontrola před odevzdáním** — `submit_check` odmítne ukázkový text, chybějící abstrakt či zadání, obrázky bez `alt` i zapomenutá `#todo`.
- ♿ **Archivní a přístupné PDF** — PDF/A-3b a PDF/UA-1 jedním přepínačem kompilátoru.
- ✍️ **Pracovní režim** — široký okraj na poznámky, `#todo` / `#note` viditelné jen v draftu, rychlejší sazba.
- ⚡ **Rychlá a štíhlá** — ukázková práce se vysází za ~0,25 s; jediné závislosti jsou `vlna` a `codly`.

<div align="center">
<img src=".github/assets/faculties.webp" alt="Titulní strany pro FVL, FVT, VLF a Univerzitu obrany" width="100%">
<br><sub>Titulní strana pro <code>fvl</code>, <code>fvt</code>, <code>vlf</code> a <code>uo</code> — logo, název fakulty i město se nastaví samy.</sub>
</div>

## Rychlý start

> [!NOTE]
> Dokud šablona není v [Typst Universe](https://typst.app/universe/), instaluje se jako **lokální balíček**: celý repozitář (složka s `typst.toml`) patří do složky lokálních balíčků Typstu.

**1. Nainstaluj šablonu** (Linux):

```bash
git clone https://github.com/iamanro/uo-thesis.git ~/.local/share/typst/packages/local/unob-thesis/0.1.0
```

<details>
<summary>macOS, Windows a instalace bez Gitu</summary>

| Systém | Složka balíčku |
|---|---|
| Linux | `~/.local/share/typst/packages/local/unob-thesis/0.1.0/` |
| macOS | `~/Library/Application Support/typst/packages/local/unob-thesis/0.1.0/` |
| Windows | `%APPDATA%\typst\packages\local\unob-thesis\0.1.0\` |

Bez Gitu: na [stránce repozitáře](https://github.com/iamanro/uo-thesis) klikni na **Code ▸ Download ZIP** a obsah rozbaleného archivu (`typst.toml`, `src/`, `template/`, …) přesuň do složky balíčku z tabulky.

</details>

**2. Založ projekt** — vznikne složka `moje-prace` s `main.typ`, `config.toml`, kapitolami a fonty:

```bash
typst init @local/unob-thesis:0.1.0 moje-prace
```

Bez příkazové řádky Typstu stačí zkopírovat obsah složky `template/` do nové složky.

**3. Piš a sázej** — vyber si editor:

<details open>
<summary><b>VS Code + Tinymist</b> (lokálně, doporučeno)</summary>

1. Nainstaluj [VS Code](https://code.visualstudio.com/) a z Marketplace rozšíření **Tinymist Typst**.
2. Otevři složku projektu (`File ▸ Open Folder…`).
3. Nastav volbu `tinymist.fontPaths` na `fonts`, aby se použily přibalené fonty (nebo je nainstaluj systémově — viz Fonty v [Referenci](#reference)).
4. Otevři `main.typ` a klikni vpravo nahoře na **Preview** — Typst sází živě, jak píšeš.
5. PDF vyexportuješ příkazem **Typst: Export to PDF** (`Ctrl/Cmd+Shift+P`), z příkazové řádky `typst compile --font-path fonts main.typ`.

</details>

<details>
<summary><b>Typst Web App</b> (v prohlížeči, bez instalace)</summary>

Webová aplikace lokální balíčky (`@local/…`) nevidí, proto do projektu nahraješ i zdrojový kód šablony:

1. Na [typst.app](https://typst.app/) vytvoř prázdný projekt (**Empty project**).
2. Z repozitáře přetáhni **obsah složky `template/`** (včetně `fonts/`) a vedle něj **složku `src/`**.
3. V `main.typ` nahraď `"@local/unob-thesis:0.1.0"` za `"src/lib.typ"` a v souborech v `chapters/` za `"../src/lib.typ"`.
4. Otevři `main.typ`; PDF stáhneš tlačítkem **Download PDF**.

</details>

> [!TIP]
> Až bude šablona v Typst Universe, projekt založíš jediným příkazem `typst init @preview/unob-thesis` — bez instalace.

## Psaní práce

Metadata vyplňuješ v **`config.toml`**, text v samostatných souborech:

```toml
lang    = "cs"
faculty = "fvl"        # fvl | fvt | vlf | uo; s logem UO: uo-fvl | uo-fvt | uo-vlf

[thesis]
type  = "master"       # bachelor | master | doctoral
title = "Název práce"

[author]
name    = "Jan"
surname = "Novák"
sex     = "M"          # M | F — rodové tvary (Zpracoval/Zpracovala…)

[supervisor]
name    = "Jana"
surname = "Nováková"
sex     = "F"

[keywords]
czech   = "první, druhé, třetí"
english = "first, second, third"
```

**`main.typ`** je pevná kostra — běžně do ní jen přidáš `#include` nové kapitoly:

```typ
#import "@local/unob-thesis:0.1.0": *

#let glossary = toml("glossary.toml")

#show: unob-thesis.with(
  ..thesis-config(toml("config.toml")),
  acronyms: glossary, terms: glossary, symbols: glossary,
  bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true),
  acknowledgement: include "front/acknowledgement.typ",
  abstract: (
    czech: include "front/abstract-cs.typ",
    english: include "front/abstract-en.typ",
  ),
  introduction: include "chapters/00-introduction.typ",
  appendix: [#include "appendix.typ"],
  // Výjimečné změny patří sem ZA spread — přepíšou hodnotu z config.toml.
)

#include "chapters/01-theory.typ"

#conclusion[#include "chapters/99-conclusion.typ"]
```

| Co | Kam |
|---|---|
| Metadata a přepínače (fakulta, typ, název, osoby, klíčová slova) | `config.toml` — každý klíč má komentář |
| Text kapitol (`=` kapitola, `==` / `===` podkapitoly) | `chapters/*.typ` |
| Abstrakty a poděkování | `front/*.typ` |
| Zkratky, pojmy a symboly — v textu `#trm("iso")` | `glossary.toml` |
| Literatura — v textu `@klíč` | `references.bib` |
| Přílohy | `appendix.typ` |

```
moje-prace/
├── config.toml       metadata a přepínače práce
├── main.typ          kostra: načtení configu, úvodní části, #include kapitol
├── glossary.toml     zkratky, pojmy, symboly
├── references.bib    zdroje
├── front/            abstract-cs.typ, abstract-en.typ, acknowledgement.typ
├── chapters/         00-introduction.typ, 01-theory.typ, …, 99-conclusion.typ
├── appendix.typ      přílohy
└── fonts/            TeX Gyre (Termes, Termes Math, Cursor)
```

V souborech kapitol importuj pomocné funkce **z balíčku** (`#import "@local/unob-thesis:0.1.0": trm, flex-caption`), ne z `src/…`. Novou kapitolu přidej řádkem `#include` v `main.typ` před `#conclusion[…]`.

> [!IMPORTANT]
> Před odevzdáním zapni v `config.toml` **`submit_check = true`** a nech `draft = false`. Šablona odmítne ukázkový obsah, chybějící abstrakt, úvod, zadání či klíčová slova, obrázky bez `alt` textu a zbylá `#todo`.

## Reference

<details>
<summary><b>Parametry šablony</b></summary>

Metadata se čtou z `config.toml` přes `thesis-config()`. Všechny parametry lze zadat i přímo v `unob-thesis.with(...)` — hodnota uvedená za spreadem má přednost. Obsahové parametry (`abstract`, `introduction`, `bibliography`, `appendix`, …) se zadávají vždy v `main.typ`.

| Parametr | Typ / hodnoty | Výchozí | Popis |
|---|---|---|---|
| `lang` | `"cs"` \| `"en"` | `"cs"` | Jazyk dokumentu |
| `draft` | bool | `false` | Pracovní režim (viz Draft a final níže) |
| `faculty` | `"fvl"` \| `"fvt"` \| `"vlf"` \| `"uo"` \| `"uo-fvl"` \| `"uo-fvt"` \| `"uo-vlf"` | `"uo"` | Fakulta; varianty `uo-*` = fakulta s logem Univerzity obrany |
| `programme` | obsah / řetězec | `[]` | Studijní program |
| `specialisation` | obsah / řetězec | `[]` | Studijní specializace (u disertace se sází jako „Zaměření studia") |
| `thesis` | `(type, title)` | — | `type`: `"bachelor"` \| `"master"` \| `"doctoral"` |
| `author` | `person(...)` | — | Autor práce |
| `supervisor` | `person(...)` | — | Vedoucí / školitel |
| `first_advisor` | `person(...)` | prázdný | Odborný konzultant |
| `second_advisor` | `person(...)` | prázdný | Školitel-specialista (jen u disertace) |
| `assignment_front` | `none` \| `false` \| obsah | `none` | Líc zadání — sken či export png/jpg/pdf, např. `image("zadani-lic.pdf", alt: "Zadání práce")`; `none` = místo pro zadání, `false` = bez strany |
| `assignment_back` | `none` \| `false` \| obsah | `none` | Rub zadání |
| `acknowledgement` | `false` \| obsah | `false` | Poděkování |
| `declaration` | bool | `true` | Čestné prohlášení |
| `ai_used` | bool | `false` | Odstavec o použití AI v prohlášení |
| `abstract` | `(czech, english)` | prázdné | Abstrakty |
| `keywords` | `(czech, english)` | prázdné | Klíčová slova (řetězce oddělené čárkou) |
| `introduction` | obsah | `[]` | Úvod |
| `acronyms` / `terms` / `symbols` | `false` \| `true` \| slovník | `false` | Glosář (viz Glosář níže); všechny tři musí předat tentýž glosář |
| `outlines` | slovník | viz níže | Generované seznamy |
| `theme` | slovník | viz níže | Barvy |
| `bibliography` | `none` \| `bibliography(...)` \| pole | `none` | Bibliografie |
| `appendix` | `none` \| obsah | `none` | Přílohy |
| `submit_check` | bool | `false` | Přísná kontrola před odevzdáním |
| `vlna` | bool \| `auto` | `auto` | Nezlomitelné mezery; `auto` = zapnuto ve final, vypnuto v draftu |
| `fancy_heading` | bool | `false` | Živé záhlaví s názvem kapitoly |
| `twoside` | bool | `true` | Oboustranný tisk (kapitoly na liché straně, vakáty); `false` = elektronická verze |

- `outlines` (bool): `headings`, `acronyms`, `terms`, `symbols`, `figures`, `tables`, `equations`, `listings`.
- `theme`: `color` (hlavní vypínač barev), `links_colored`, `faculty_colored`, `faculty_color` (vlastní hex nebo `none`), `link_color`.
- `person(prefix, name, surname, suffix, sex, genitive)`: `sex` je `"M"`, `"F"` nebo `none` (pak mužské tvary); `genitive` je ruční 2. pád celého jména pro prohlášení.

</details>

<details>
<summary><b>Veřejné API</b></summary>

Balíček (`src/lib.typ`) exportuje:

| Funkce | Účel |
|---|---|
| `unob-thesis` | Hlavní šablona pro `#show` |
| `thesis-config(...)` | Převod `toml("config.toml")` na parametry šablony (osoby obalí přes `person`, překlep v klíči ohlásí) |
| `person(...)` | Autor, vedoucí, konzultanti |
| `conclusion[...]` | Závěr práce (lokalizovaný nečíslovaný nadpis + obsah) |
| `trm("klic", style:, case:, display:)` | Zkratka nebo pojem z glosáře |
| `singular`, `plural`, `first`, `first-plural` | Styly pro `trm` |
| `flex-caption(dlouhý, krátký)` | Dlouhý popisek pod figurou, krátký v seznamech |
| `todo[...]`, `note[...]` | Poznámky viditelné jen v draftu (`todo` blokuje `submit_check`) |
| `landscape[...]` | Otočí širokou tabulku/obrázek o 90° na stojaté straně; obsah se musí vejít na jednu stranu |
| `appendix[...]` | Nízkoúrovňový režim příloh (běžně stačí parametr `appendix`) |
| `vlna-on()`, `vlna-off()`, `vlna-debug-on()`, `vlna-debug-off()` | Přepínání nezlomitelných mezer v části textu |

</details>

<details>
<summary><b>Glosář</b></summary>

Zkratky, pojmy i symboly jsou v jednom `glossary.toml`, jedna TOML tabulka na položku:

```toml
[iso]
short = "ISO"
en = "International Organization for Standardization"
cs = "Mezinárodní organizace pro standardizaci"

[zero_trust]
short = "Zero Trust"
cs = "nulová důvěra"
glossary = "Bezpečnostní model, který implicitně nedůvěřuje žádnému prvku sítě."

[rho]
symbol = "rho"
symbol_alt = "ró, hustota"
unit = "kg m^(-3)"
unit_alt = "kilogram na metr krychlový"
cs = "hustota"
```

- Položka **bez** `glossary` je **zkratka** (SEZNAM ZKRATEK); `short` smí obsahovat mezeru (`MO ČR`).
- Položka **s** `glossary` je **pojem** (SEZNAM POJMŮ s definicí).
- Položka se `symbol` je **symbol** (SEZNAM SYMBOLŮ, sází se matematicky); `unit` je jednotka.
- Pole: `short`, `en` a `cs` (rozvinutý tvar), volitelně `plural`, `longplural` (anglický plurál), `csplural` (český plurál). Pro PDF/UA doplň u symbolů `symbol_alt` a `unit_alt` — šablona popisy nevymýšlí.

V textu: `#trm("iso")` sází vždy krátký tvar. Klíč se hledá přesně, pak bez ohledu na velikost písmen a nakonec podle `short`; neznámý klíč ohlásí podobné položky. Zkratku při prvním použití zaveď sám přes `#trm("iso", style: first)`; množné číslo `style: plural`, český pád `case: 1–7` (jen zkratky), vlastní skloňovaný tvar `display: [normy ISO]`. Seznamy vypisují všechny položky z `glossary.toml`, ať jsou v textu použité, nebo ne.

Předávej `acronyms: toml("glossary.toml")`, aby se projevily tvé úpravy; `acronyms: true` načte jen demo glosář z balíčku.

</details>

<details>
<summary><b>Bibliografie</b></summary>

Nativní Typst `bibliography(...)`. Styl `iso-690-numeric` odpovídá ČSN ISO 690 a je vestavěný:

```typ
bibliography: bibliography("references.bib", style: "iso-690-numeric", full: true)
```

Více seznamů s vlastními nadpisy (případně vlastní CSL):

```typ
bibliography: (
  bibliography("knihy.bib", style: "iso-690-numeric", full: true, title: [Knihy]),
  bibliography("online.bib", style: "iso-690-numeric", full: true, title: [Online zdroje]),
)
```

Vypnutí: `bibliography: none`.

</details>

<details>
<summary><b>Skloňování jména vedoucího</b></summary>

Čestné prohlášení je vždy česky a jméno vedoucího se skloňuje do 2. pádu automaticky. Když heuristika selže, zadej tvar ručně — v `config.toml` jako `genitive = "Jana Kadlece"`, inline takto:

```typ
supervisor: person(name: "Jan", surname: "Kadlec", sex: "M", genitive: "Jana Kadlece")
```

</details>

<details>
<summary><b>Draft a final, seznamy, přílohy</b></summary>

**Draft a final.** `draft: true` je pro psaní: bez titulní strany a úvodních částí, široký pravý okraj na poznámky, viditelná `#todo` / `#note`, rychlejší sazba. **Final** je odevzdávaná verze s titulní stranou, prohlášením a seznamy. Čísla stran se tisknou od OBSAHU; počítají se ale od titulní strany, aby lichá čísla zůstala na lících.

**Generované seznamy.** Seznamy obrázků, tabulek, rovnic a výpisů se vysází, jen když dokument odpovídající položky obsahuje; seznamy zkratek, pojmů a symbolů, když je obsahuje glosář — i při `outlines.*: true`.

**Přílohy.** Předávají se jako obsah: `appendix: [#include "appendix.typ"]`. Každá příloha (`= Název`) začíná na nové straně, stránky i figury se číslují `A–1`, rovnice `(A–1)`. Figury příloh nejsou v seznamech obrázků a tabulek. Bez H1 nadpisu se nevysází ani SEZNAM PŘÍLOH; v hlavním obsahu je jen SEZNAM PŘÍLOH, jednotlivé přílohy jsou v záložkách PDF.

</details>

<details>
<summary><b>Fonty</b></summary>

Šablona používá rodinu **TeX Gyre**, přibalenou ve složce `fonts/` projektu (v repozitáři `template/fonts/`): `TeX Gyre Termes` (text), `TeX Gyre Termes Math` (matematika), `TeX Gyre Cursor` (kód).

Ve webové aplikaci se fonty z projektu načtou samy. Lokálně předej `--font-path fonts`, nebo fonty nainstaluj systémově. Celou rodinu najdeš na [CTAN](https://mirrors.ctan.org/fonts/tex-gyre.zip).

</details>

<details>
<summary><b>Vzhled a typografie (<code>src/config.toml</code>)</b></summary>

Všechny laditelné hodnoty sazby jsou v [`src/config.toml`](src/config.toml): velikosti nadpisů, písma, řádkování, odsazení, okraje, tabulky, titulní strana a barvy fakult. Délky se píšou jako řetězec s jednotkou (`"12pt"`, `"0.7em"`, `"35mm"`, `"47%"`):

```toml
[heading]
h1_size = "16pt"
```

Sekce `[faculty]` obsahuje oficiální barvy fakult — neměň je bez svolení Univerzity obrany (viz [`NOTICE`](NOTICE)).

</details>

<details>
<summary><b>Doplňkové balíčky</b></summary>

Šablona záměrně neexportuje boxy, callouty ani kreslicí nástroje. Když potřebuješ víc, importuj balíčky z Typst Universe přímo v práci: `@preview/showybox`, `@preview/frame-it`, `@preview/cetz`, `@preview/fletcher`, `@preview/physica`, `@preview/zero`, `@preview/subpar`.

> [!WARNING]
> **Neimportuj `@preview/vlna`.** Nezlomitelné mezery řeší šablona sama (`@preview/vlna:0.3.0` v `src/styling/packages.typ`). Druhé `#show: apply-vlna` aplikuje pravidla dvakrát — výsledek je stejný, ale kompilace se zpomalí (544stránková disertace: 7,9 s → 11,2 s). Pro část textu použij `#vlna-off()` / `#vlna-on()`.

</details>

<details>
<summary><b>Dobrá praxe a přístupnost</b></summary>

- Nahraď veškerý ukázkový obsah (text, reference, glosář, metadata) vlastním a před odevzdáním zapni `submit_check`.
- **Přístupnost (PDF/UA):** u každého obrázku doplň `alt`, zejména u skenu zadání: `assignment_front: image("zadani.png", alt: "Zadání práce")`. Jazyk dokumentu, metadata a `alt` log nastavuje šablona; Typst exportuje otagované PDF.
- **Archivní PDF:** `typst compile --pdf-standard a-3b,ua-1 main.typ`. Shodu ověř nástrojem [veraPDF](https://verapdf.org/); úspěšný export nenahrazuje kontrolu čtečkou.
- **Elektronická vs. tištěná verze:** pro elektronické PDF vypni vakáty `twoside = false`, tištěná verze zůstává `twoside = true`.
- Preferuj vektorovou grafiku (`.svg`) a větší obrázky před odevzdáním zmenši.

</details>

## Vývoj

```bash
python3 -m unittest discover -s tests -v       # regresní testy (Typst + Poppler)
python3 scripts/ci.py check --output dist      # totéž co CI: balíček, typst init, 9 PDF
```

Chceš přispět? Postup, struktura kódu a zásady jsou v [`CONTRIBUTING.md`](.github/CONTRIBUTING.md); chyby a návrhy hlas přes [Issues](https://github.com/iamanro/uo-thesis/issues/new/choose).

<details>
<summary><b>Testy a náhled úprav</b></summary>

Testy kompilují skutečná PDF v dočasných složkách přes veřejné rozhraní: glosář (vyhledání, kolize, neznámé položky, odkazy podle dostupnosti seznamů), `submit_check` a skloňování jména vedoucího. Vyžadují Python 3, Typst a `pdftotext` (Poppler); proměnná `TYPST` určí konkrétní binárku.

Ruční náhled úprav šablony — propoj repozitář jako lokální balíček (Linux) a sázej ukázkový projekt:

```bash
mkdir -p ~/.local/share/typst/packages/local/unob-thesis
ln -sfn "$PWD" ~/.local/share/typst/packages/local/unob-thesis/0.1.0
typst watch --font-path template/fonts template/main.typ
```

U velkých prací vyzkoušej `--jobs 8` místo automatického počtu vláken (na 32vláknovém stroji bylo méně vláken rychlejší). Pro psaní používej `draft: true`; vypnutí vlny mění typografii, není to bezeztrátová optimalizace.

</details>

<details>
<summary><b>CI/CD a vydání</b></summary>

Workflow **Typst CI** (`.github/workflows/ci.yml`) běží pro pull requesty, `main` a ruční spuštění: Ubuntu 24.04, Typst z `package.compiler` v `typst.toml` s ověřeným SHA-256, jen přibalené fonty, akce připnuté na commity, jen právo čtení. Spustí testy, z archivu balíčku **skutečně nainstaluje šablonu přes `typst init @local/…`** a vysází sedm profilů (CS/EN, final/draft, všech sedm variant fakulty, jedno- i oboustranná sazba, živé záhlaví) plus PDF/A-3b a PDF/UA-1. Varování kompilátoru jsou chyba. Artefakt `typst-dist` (PDF, `unob-thesis-<verze>.tar.gz`, `build-info.json`, `SHA256SUMS`) se drží 14 dní.

Lokálně (Python 3.12+, Git, Poppler; instalátor pro Linux x86_64):

```bash
bash scripts/install-typst.sh /tmp/unob-typst
TYPST=/tmp/unob-typst/typst python3 scripts/ci.py check --output dist
(cd dist && sha256sum --check --strict SHA256SUMS)
```

Výstupní složka musí být prázdná; archiv obsahuje jen verzované soubory (nové přidej `git add`). Při změně kompilátoru aktualizuj checksum v `scripts/install-typst.sh`.

**Vydání:** po změně `package.version` a importů v šabloně pushni tag `v<package.version>`. Workflow **Typst release** zopakuje celou kontrolu a teprve pak založí GitHub Release s otestovanými artefakty; jiný tag odmítne a existující vydání nepřepíše. Stačí omezený `GITHUB_TOKEN`; do Typst Universe se nic nepublikuje automaticky.

</details>

## Licence

| Část | Licence |
|---|---|
| Kód balíčku (`src/`, nástroje repozitáře) | [AGPL-3.0-or-later](LICENSE) |
| Startovní projekt (`template/` bez fontů) — soubory, které `typst init` zkopíruje do tvé práce | [MIT-0](LICENSE-MIT-0): použij, uprav a šiř bez omezení a bez uvedení autora |
| Fonty TeX Gyre (`template/fonts/`) | GUST Font License |
| Loga Univerzity obrany (`src/assets/logo*.svg`) | Vlastní podmínky UO, viz [`NOTICE`](NOTICE) |

Loga fakult a univerzity jsou duševním vlastnictvím Univerzity obrany a **nejsou** kryta licencí AGPL ani MIT-0 — smí se použít jen ve skutečné závěrečné práci na Univerzitě obrany a nesmí se upravovat (viz [`NOTICE`](NOTICE)). Ověř si, že použití log odpovídá pravidlům Univerzity obrany a tvé fakulty.
