# Changelog

Všechny významné změny šablony `unob-thesis`. Formát vychází z
[Keep a Changelog](https://keepachangelog.com/cs/1.0.0/),
verzování dle [SemVer](https://semver.org/lang/cs/).

## [Nevydáno]

### Přidáno
- **Ukázková diplomová práce** (`examples/diplomka/`, 40 stran, z toho 19 stran textu): fiktivní práce o modelování
  vybíjení Li-ion článku s matematikou a číslovanými rovnicemi, chemií (`typsium`), fyzikou
  (`physica`), jednotkami a nejistotami (`zero`), grafy a kresbami (`cetz`, `cetz-plot`), schématem
  (`fletcher`), podobrázky (`subpar`), výpisy kódu v Pythonu, Rustu a Typstu, glosářem se symboly,
  přílohami, stranou na šířku a `submit_check`. CI ji sází a přikládá k vydání.
- **Validace veraPDF v CI** — PDF/A-3b (šablona i ukázková práce) a PDF/UA-1 (šablona) prochází validátorem
  veraPDF (obraz `verapdf/cli` připnutý na digest); dříve se ověřovalo jen, že Typst export dokončí.
- **Snapshoty sazby v CI** — text každé strany sedmi profilů a ukázkové práce se porovnává
  s `tests/snapshots/`; nezáměrná změna sazby shodí CI. Záměrnou změnu zapíše
  `UPDATE_SNAPSHOTS=1 python3 scripts/ci.py check`.

### Změněno
- **Vzhled tabulek** — záhlaví má jemné podbarvení (barva fakulty, bez barev šedá), řádky těla střídavé
  pruhy a tenká linka pod hlavičkou; vnější linky zůstávají a nezakrývá je podbarvení.

### Opraveno
- **`submit_check` a výpisy kódu** — ikony jazyka v `codly` jsou obrázky bez `alt`, takže práce s výpisem
  kódu neprošla kontrolou a nešla exportovat jako PDF/UA. Ikony jsou vypnuté, název jazyka zůstává.
- **Číslování výpisů** — čítač výpisů se nenuloval v kapitolách a přílohách (příloha začínala „B–4“).
  Nyní se nuluje spolu s obrázky, tabulkami a rovnicemi.
- **Dokumentace PDF/UA** — README a tahák výslovně uvádějí, že PDF/UA-1 vyžaduje `alt` u každé rovnice,
  takže pro práce s matematikou je prakticky nedosažitelné; doporučený export je PDF/A-3b.

### Změněno
- **Závislosti** — `@preview/vlna` 0.3.0 → 0.4.0 (vysázené stránky beze změny).
  `codly`, `codly-languages` a Typst 0.15.1 jsou aktuální.

## [0.1.0] – 2026-10-09

První vydání šablony.

### Přidáno
- **Šablona závěrečných prací Univerzity obrany** — bakalářská, diplomová
  a disertační práce pro fakulty `fvl`, `fvt`, `vlf`, `uo` a varianty `uo-*`
  s logem Univerzity obrany; sazba česky i anglicky.
- **Konfigurace v `config.toml`** — `thesis-config` převede metadata na
  parametry šablony a ohlásí neznámý klíč. Úvodní části se předávají parametry
  `acknowledgement`, `abstract` a `introduction`, závěr helperem `#conclusion`.
- **Úvodní části** — titulní strana s barevným logem fakulty, zadání (sken
  png/jpg/pdf nebo místo pro vložení), poděkování, čestné prohlášení (odstavec
  o AI, rodové tvary, jméno vedoucího automaticky ve 2. pádě nebo ručně přes
  `genitive`), abstrakty a klíčová slova; zástupné texty pro prázdné části.
- **Generované seznamy** — obsah, zkratky, pojmy, symboly (s jednotkami
  a alternativním textem pro PDF/UA), obrázky, tabulky, rovnice, výpisy
  a přílohy; seznam se vysází jen s reálnými položkami.
- **Glosář v jednom `glossary.toml`** — `#trm` se styly `singular`, `plural`,
  `first`, `first-plural`, českými pády a vlastním tvarem (`display`),
  prolinkování do seznamů, víceslovné zkratky, kontrola kolizí klíčů
  i krátkých tvarů a nápověda u neznámého klíče.
- **Sazba** — číslování kapitol, figur `1.1` a rovnic `(1.1)`, přílohy
  s číslováním `A–1`, `flex-caption`, booktabs tabulky, výpisy kódu (`codly`),
  `#landscape`, živé záhlaví, jednostranná i oboustranná sazba s vakáty,
  nezlomitelné mezery (`vlna`, v draftu automaticky vypnuté).
- **Bibliografie** — nativní `bibliography(...)` se stylem ČSN ISO 690, jeden
  i více seznamů.
- **Pracovní režim** — `draft: true` se širokým okrajem a poznámkami
  `#todo` / `#note`.
- **Kontrola před odevzdáním** — `submit_check` odmítne ukázkový obsah,
  chybějící abstrakt, úvod, klíčová slova, bibliografii nebo zadání, obrázky bez
  `alt` a zbylá `#todo`.
- **Archivní a přístupné PDF** — export PDF/A-3b a PDF/UA-1, metadata PDF
  (autor, název, popis, klíčová slova).
- **Typografie v `src/config.toml`** — laditelné velikosti, okraje, řádkování,
  tabulky a titulní strana; přibalené fonty TeX Gyre.
- **Licence** — kód balíčku pod AGPL-3.0-or-later; startovní projekt
  `template/` (soubory, které `typst init` zkopíruje do práce) pod MIT-0, aby
  ho studenti mohli volně upravovat a šířit; loga UO a fonty TeX Gyre mají
  vlastní podmínky (viz `NOTICE`).
- **CI/CD** — regresní testy přes veřejné rozhraní, instalace balíčku přes
  `typst init`, sedm profilů šablony plus PDF/A-3b a PDF/UA-1, vydání
  otestovaných artefaktů z tagu `v<verze>`.

[Nevydáno]: https://github.com/iamanro/uo-thesis/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/iamanro/uo-thesis/releases/tag/v0.1.0
