# Changelog

Všechny významné změny šablony `unob-thesis`. Formát vychází z
[Keep a Changelog](https://keepachangelog.com/cs/1.0.0/),
verzování dle [SemVer](https://semver.org/lang/cs/).

## [Nevydáno]

### Přidáno
- **Ukázková diplomová práce** (`examples/diplomka/`) — cca 10 stran textu
  předvádějících všechny funkce: citace (ISO 690), glosář `#trm` (zkratky,
  pojmy, množné číslo), symboly s jednotkami, číslované rovnice s křížovými
  odkazy, figury s `flex-caption`, tabulky, výpisy kódu, `#landscape`
  otočenou tabulku, `#todo`/`#note` i placeholder zadání. Do balíčku se nedistribuuje
  (`exclude`), kompilace: `typst compile --root . --font-path template/fonts
  examples/diplomka/main.typ`.

### Změněno
- **`#landscape[...]` otáčí obsah, ne stránku** — tabulka/obrázek se otočí
  o 90° na stojaté straně (horní okraj ke hřbetu, čtenář otáčí dokument po
  směru hodin); číslo strany i živé záhlaví zůstávají v normální poloze.
  Dříve se překlápěla celá strana (`page(flipped: true)`). Obsah se musí
  vejít na jednu stranu — rotovaný blok se nezalamuje.

### Opraveno
- **Živé záhlaví (`fancy_heading`)** — na první straně kapitoly se sázel název
  *předchozí* kapitoly (`query(..before(here()))` nadpis na aktuální straně
  nevidí); nyní se záhlaví na první straně kapitoly správně potlačí. V zadní
  části (ZÁVĚR, BIBLIOGRAFIE, seznamy příloh) záhlaví mlčí — dřív neslo název
  poslední číslované kapitoly.

## [0.4.0] – 2026-07-30

Universe-ready šablona: metadata v `config.toml`, texty v `front/` a `chapters/`,
`main.typ` jako pevná kostra. Nové autorské funkce (seznam symbolů, běžné záhlaví,
`vlna: auto`, `#todo`/`#note`, přepnutí na šířku), export PDF/A a PDF/UA, přísnější
`submit_check`, barevná vektorová loga a fakulty s logem UO. Každá změna prošla
branou: kompilace obou entrypointů, kompilační matice (48 kombinací) a reálná disertace.

### Přidáno
- **Seznam symbolů** — položky glosáře s klíčem `symbol` (a volitelně `unit`)
  se vysází do SEZNAMU SYMBOLŮ (`symbols: ...`, `outlines.symbols: true`).
  Symbol i jednotka se sázejí matematicky, jednotky vzpřímeně (`kg m^(-3)`).
- **Běžné („živé") záhlaví** — parametr `fancy_heading: true` vysází název
  aktuální kapitoly na vnější okraj (oboustranný tisk); potlačeno na obálce,
  v úvodních částech, seznamech a na první straně kapitoly.
- **Přepínač `vlna: auto|true|false`** — výchozí `auto` zapne nezlomitelné
  mezery ve final a vypne v draftu: řeší finální řádkové zlomy, v draftu jen
  zdražují psací smyčku (na velkých dokumentech +40–75 % času sazby).
- **Autorské pomůcky** `#todo[...]`, `#note[...]` (viditelné jen v draftu) a
  `#landscape[...]` (obsah na stranu na šířku pro široké tabulky/obrázky).
- **PDF/A a PDF/UA export** — `task pdfa` (a-3b), `task pdfua` (ua-1) a
  `task archive` (obojí) pro archivní a přístupné odevzdání.
- `submit_check: true` nově odmítne nevyřešené značky `#todo(...)` (vypíše
  strany) a vyžaduje alespoň tři klíčová slova v obou jazycích.
- **Přepínač `twoside: true|false`** (inspirace: modern-nju-thesis) — `false`
  vypne vakáty a střídání okrajů pro elektronickou verzi; kapitoly a přílohy
  začínají na nové straně místo liché. Výchozí `true` = dosavadní chování.
- **Hloubka OBSAHU v `config.toml`** (`[outline] depth`, dosud zadrátovaná 3)
  — po vzoru `toc-depth` ze supercharged-dhbw.
- README doporučuje ověření archivního PDF nástrojem **veraPDF** před
  odevzdáním (praxe scholarly-tauthesis, oficiální šablony Tampere University).
- **Metadata práce v `config.toml`** — nový helper `thesis-config()` načte
  metadata a přepínače ze souboru `config.toml` v projektu
  (`unob-thesis.with(..thesis-config(toml("config.toml")), …)`); osoby obalí
  přes `person(...)`, překlep v klíči okamžitě ohlásí. Obsahové části
  (abstrakt, úvod, bibliografie, přílohy) zůstávají v `main.typ`. Inline
  konfigurace parametry `unob-thesis.with(...)` dál funguje beze změny.
- **Universe-ready výchozí tok** — `template/main.typ` je pevná kostra:
  `unob-thesis.with(..thesis-config(toml("config.toml")), …)` + úvodní části
  přes helpery (`#abstract-cs[…]`, `#introduction[…]`, …) ze souborů `front/`
  a `chapters/`. Uživatel po `typst init @preview/unob-thesis` edituje jen
  `config.toml` a textové soubory; `.with(...)` slouží pouze pro výjimečné
  přepisy za spreadem. `typst.toml` doplněn o `keywords`.
- **Fakulty s logem UO** — nové hodnoty `faculty: "uo-fvl" | "uo-fvt" | "uo-vlf"`:
  název, barva i město základní fakulty, ale logo Univerzity obrany. Samotné
  `uo` zůstává bez fakultní řádky, `fvl`/`fvt`/`vlf` s fakultním logem.
- **Popisek specializace podle typu práce** — Bc./Ing. „Studijní specializace",
  Ph.D. „Zaměření studia" (EN „Field of Study").
- **`task new-chapter -- Název kapitoly`** — založí `chapters/NN-nazev.typ`
  s nadpisem a vypíše `#include` řádek k vložení do `main.typ`. Používá jen
  shell builtiny Tasku + Python, takže funguje i na Windows (cmd/PowerShell).
- **`--ignore-system-fonts` ve všech Taskfile příkazech** — systémový font
  nemůže zastínit bundlované TeX Gyre (lokální build ≡ CI ≡ Universe) a
  odpadá sken systémových fontů.
- **Přehlednější ukázková šablona** — `template/main.typ` je nově jen
  konfigurace; abstrakt, poděkování, úvod, kapitoly a závěr jsou v samostatných
  souborech (`front/`, `chapters/`) a vkládají se přes `#include`. Kapitoly
  importují `#trm`/`flex-caption` z balíčku, ne z interních cest `src/…`.
- **Vendorovaná vlna 0.4.0** (`src/styling/vlna.typ`) místo vlastní minimální
  implementace. Nezlomitelné mezery se nově vkládají `box`em, ne přepisem textu
  na `nbsp`, takže **zůstává funkční skok do zdroje**. Pokrývá pravidla ÚJČ pro
  čísla a jednotky (`10 %`, `19 °C`), data (`21. 6. 2024`), poměry (`1 : 50 000`),
  složené zkratky (`a. s.`, `PS PČR`), pomlčky a zalamování odkazů; nově váže
  i přes hranici elementu (`viz #link(..)`).
- `lib.typ` exportuje `vlna-off()`, `vlna-on()`, `vlna-debug-on()`,
  `vlna-debug-off()` pro vypnutí vlny v části textu.
- Validace typu parametrů `outlines` a `theme` — neplatný vstup se dřív tiše
  ignoroval a použily se výchozí hodnoty.
- Validace polí `plural` / `csplural` / `longplural` v glosáři.
- Jazyk dokumentu v PDF metadatech (PDF/UA, čtečky obrazovky).
- `scripts/` — brána, driver a benchmark pro automatizovaná vylepšení
  (z balíčku vylučuje `.gitattributes` i `typst.toml`).

### Opraveno
- **Validační hlášky byly nečitelné.** `panic-i18n` volal `panic(t(key))`, ale
  `t()` bez parametru `lang` vrací `context` — uživatel proto místo hlášky viděl
  `error: panicked with: context()`. Týkalo se to všech kontrol vedených přes
  `panic-i18n`, takže `submit_check: true` nikdy neřekl, co je špatně. Jazyk se
  nyní vyhodnotí uvnitř kontextu. (Bug byl už v 0.3.0.)
- **Fonty v `src/config.toml` neodpovídaly přibaleným ani dokumentaci.**
  Konfigurace žádala Libertinus Serif / New Computer Modern Math / JetBrainsMono
  NF, zatímco `template/fonts/` i README uvádějí TeX Gyre. Libertinus a New CM
  má typst vestavěné, takže se sázely bez varování — jen jiným písmem, než
  README slibuje. `JetBrainsMono NF` ale vestavěný není ani přibalený, takže
  u kódu docházelo k tiché náhradě (DejaVu Sans Mono). Sjednoceno na přibalené
  TeX Gyre; ověřeno vloženými fonty v PDF (dřív `LibertinusSerif`, nyní
  `TeXGyreTermes`).
- **Nadpisy H4 nešlo referencovat.** Šablona jim vypínala číslování, takže
  `#ref(<h4-nadpis>)` skončil chybou „cannot reference heading without
  numbering". Reálná disertace to používá u 24 nadpisů.
- `submit_check: true` nově odmítne i zadání vypnuté hodnotou `false`
  (dřív kontrolovalo pouze `none`, takže se dalo obejít).
- Skloňování jmen kratších než tři znaky (např. „Wu", „Li") padalo na
  `IndexError` v `genitiv.typ` místo bezpečného fallbacku.
- Klíčová slova se zobrazí i při prázdném abstraktu.
- Jednotné zakončení řádků (LF) a jeho vynucení v `.gitattributes`; repozitář
  byl smíchaný CRLF/LF, což vyrábělo falešné diffy o stovkách řádků.

### Odstraněno
- **Parametr `guide` a stránka průvodce** (`guide: true`) — obsah se plně kryl
  s README, které je nově jediným zdrojem referenční dokumentace. Interní API
  stránka (`docs: true`) zůstává a je aktualizovaná na 0.4.0.
- Mrtvá hodnota `appendix-list-indent` ve `src/styling/appendix.typ`.
- Mrtvé nastavení oddělovače popisků ve `src/styling/figures.typ` (tři místa
  dělala jednu věc a `separator` neměl efekt).

### Sazba a glosář
- Svislé mezery nadpisů jsou konzistentní: nad podnadpisem (H2–H4) je stejná
  mezera jako pod H1, pod podnadpisem menší (`sub_gap`). Dřív měl podnadpis
  symetrické mezery, takže nad ním mohlo být víc místa než nad kapitolou.
- Mezeru popisku lze nastavit zvlášť pro tabulky a obrázky (zpětně kompatibilní).
- Skloňování prvního slova pojmu pokrývá víc českých zakončení; ručně zadaný
  `csplural` se respektuje i v nepřímých pádech.
- Položka glosáře bez rozvedení i definice je odmítnuta s jasnou chybou
  (dřív vznikl tichý prázdný záznam v seznamu zkratek).

### Kontroly před odevzdáním
- `submit_check: true` nově odhalí **neupravený ukázkový obsah** (název práce,
  jméno autora, abstrakt, klíčová slova) — nejčastější chybu při odevzdávání.
- `submit_check: true` vyžaduje **`alt` text u každého obrázku** (PDF/UA)
  a v chybě uvede stranu i zdroj obrázku, aby šel dohledat.
- Vstupy `person(...)` se validují: `name`/`surname` neprázdné, `sex` jen
  `"M"` / `"F"` / `none`, ostatní pole řetězec nebo `none`.
- Parametr `bibliography` odmítne cestu jako řetězec s nápovědou správného
  použití (dřív skončil nesrozumitelnou typovou chybou hluboko v sazbě).

### Nástroje
- `scripts/test-matrix.sh` — kompilační matice **48 kombinací**
  (4 fakulty × 2 jazyky × 3 typy práce × draft/final) plus cílené případy
  s glosářem, přílohou, bibliografií a `submit_check: true`.
- `scripts/check-fonts.sh` + krok v CI: fonty z `config.toml` musí být
  dostupné bez systémových fontů; CI navíc sází s `--ignore-system-fonts`.
- `scripts/check-i18n.sh` — každý překladový klíč musí mít `cs` i `en`.
- `scripts/check-package.sh` — obsah `git archive` musí odpovídat `exclude`
  v `typst.toml` (aby se do balíčku nedostal vývojový `main.typ` ani `scripts/`).
- `scripts/bench.sh` — měření kompilačního času na reálné disertaci.
- `scripts/improve-loop.sh` — brána (kompilace + pixelové srovnání + doplňkové
  kontroly + výkon) a driver pro dávkové vylepšování; viz `scripts/README.md`.

### Kompilační čas
Měřeno na reálné disertaci (544 stran, bibliografie 372 kB), prokládaně A/B/A/B.
Wall-clock je na zatíženém stroji nepoužitelný (pro tentýž vstup skákal 16–32 s),
proto se měří i CPU čas (user+sys), který má ~3× menší rozptyl:

| stav | CPU | wall |
|---|---|---|
| šablona 0.3.0 (původní) | 18,9 s | 9,3 s |
| tato verze | 25,2 s | 11,2 s |
| tato verze **bez** `@preview/vlna` v `main.typ` | **17,4 s** | **7,9 s** |

Rozdíl mezi koly < 3 %; stejné poměry vyšly i v jiném zatížení stroje
(45,1 / 59,0 / 40,6 s CPU), takže závěr na stavu stroje nezávisí.

Vlna stojí ~40 % času sazby. Ladění jejích skupin pravidel je v šumu — cena
není v šíři regexu, ale v `box`u na každý nález a u dokumentů s raw obsahem
navíc ve čtení stavu na každý nález (`glue-slow`). Kdo si vlnu importuje sám,
aplikuje ji **dvakrát** a připlatí ~45 % času; viz varování v README.

Potlačení vlny uvnitř `raw` **nelze vypnout** kvůli rychlosti: na malém testu
se nezměnilo nic (0/17 stránek), ale na reálné disertaci 360 z 544 stránek —
inline `raw` v běžném textu ovlivňuje zalomení odstavců. Zrychlení vlny proto
patří do upstreamu `typst-vlna` (zbavit se čtení stavu, ne potlačení).

Vedlejší efekt přechodu na TeX Gyre Termes: disertace má 544 stran místo 546
(Termes je kompaktnější než Libertinus Serif).

## [0.3.0] – 2026-07-16

Verze odladěná v reálném nasazení na disertační práci. Přináší přepis glosáře,
odstranění externích závislostí a řadu oprav sazby.

### Přidáno
- **Centralizovaná typografie v `src/config.toml`** – velikosti nadpisů, písma,
  řádkování a odsazení odstavce, okraje (vč. `[page.draft]`), sazba tabulek,
  mezery seznamů, barva nebarevných odkazů, titulní strana a barvy fakult jsou
  na jednom místě (načítá je `src/config.typ`), místo roztroušených hodnot ve
  `styling/*`. Chování oproti 0.2.0 zůstává identické (ověřeno pixelovým diffem).
- **`flex-caption`** – popisky obrázků a tabulek ve dvou verzích: dlouhá
  (název + zdroj) pod objektem, krátká (jen název) v Seznamu obrázků / tabulek.
  Exportováno z `lib.typ` a napojeno na generované seznamy.
- **Číselný citační styl** `src/assets/csl/numeric.csl` (vedle `harvard.csl`)
  pro číslované citace ve tvaru `[1]`.
- **Klikací prolinky glosáře** – výskyt `#trm(...)` v textu odkazuje na příslušnou
  položku v Seznamu zkratek / pojmů (pokud existuje).

### Změněno
- **Glosář přepsán na bezstavovou implementaci** (`internal/glossary/*`) stavějící
  na `query`/`context` a registru položek. Chování v seznamech je předvídatelnější
  a nezávisí na pořadí zpracování.
- **Přepracovaná titulní strana** (`cover.typ`) – zjednodušené a konzistentnější
  rozvržení a velikosti (hlavička fakulta/program/specializace, výška loga,
  pevné mezery).
- **Sazba příloh** – značka „PŘÍLOHA A" tučně + název normální vahou, bez
  tečkového vodiče; z názvů příloh v seznamu se odstraní poznámky pod čarou.
- **Oboustranný tisk** – kapitoly začínají vždy na lichém (pravém) listu;
  dorovnávací vakát je bez patičky a bez čísla stránky.
- **Knižní styl tabulek** – popisek nad tabulkou, bez oddělovače.
- `assignment_front` / `assignment_back` nově přijímají i `false` (strana zadání
  se vůbec nevysází), nejen `none` nebo obsah.
- Matematická sazba má fallback na písmo „New Computer Modern Math".

### Opraveno
- **Prázdný OBSAH** – nesoulad `supplement` mezi nadpisy a generováním obsahu
  vedl k tichému vysázení prázdného OBSAHu; sjednoceno.
- **Spolknuté chybové hlášky glosáře** – hlášky v hodnotové pozici se maskovaly
  pozdější typovou chybou; nahrazeno přímými `panic` s dvojjazyčným textem.

### Odstraněno
- Závislost na balíčku `@preview/glossarium` (nahrazena vlastním glosářem).
- Závislost na balíčku `@preview/vlna` – nahrazena vlastní `apply-vlna`
  (`src/styling/vlna.typ`), která navíc ošetřuje dvoupísmenná slova, tituly
  před/za jménem a zkratky (nezlomitelné mezery).

## [0.2.0]

Výchozí publikovaná verze šablony (glosář postavený na `@preview/glossarium`,
zalamování přes `@preview/vlna`).

[0.4.0]: https://github.com/iamanro/unob-thesis/releases/tag/v0.4.0
[0.3.0]: https://github.com/iamanro/unob-thesis/releases/tag/v0.3.0
[0.2.0]: https://github.com/iamanro/unob-thesis/releases/tag/v0.2.0
