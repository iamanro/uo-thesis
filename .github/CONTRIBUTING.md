# Jak přispět

*English: issues and pull requests are welcome in Czech or English. Run the tests and `scripts/ci.py check` before opening a PR; describe any change to the typeset PDF.*

Díky, že chceš šablonu vylepšit! Chyby a návrhy hlas přes [formuláře v Issues](https://github.com/iamanro/uo-thesis/issues/new/choose), bezpečnostní problémy soukromě podle [`SECURITY.md`](SECURITY.md).

## Vývojové prostředí

Potřebuješ Typst ve verzi z `package.compiler` v [`typst.toml`](../typst.toml), Python 3.12+, Git a `pdftotext` / `pdfinfo` (Poppler).

```bash
# Repozitář jako lokální balíček @local/unob-thesis:0.1.0 (Linux)
mkdir -p ~/.local/share/typst/packages/local/unob-thesis
ln -sfn "$PWD" ~/.local/share/typst/packages/local/unob-thesis/0.1.0

# Živý náhled ukázkového projektu
typst watch --font-path template/fonts template/main.typ

# Testy a kompletní kontrola jako v CI (balíček → typst init → 9 PDF + ukázková práce)
python3 -m unittest discover -s tests -v
python3 scripts/ci.py check --output "$(mktemp -d)"

# Záměrná změna sazby: přepiš snapshoty textu a zkontroluj diff v tests/snapshots/
UPDATE_SNAPSHOTS=1 python3 scripts/ci.py check --output "$(mktemp -d)"
```

## Kde co je

| Cesta | Obsah |
|---|---|
| `src/lib.typ` | Veřejné API balíčku — jediný soubor, který importuje uživatel |
| `src/pages/unob-thesis.typ` | Hlavní funkce: validace vstupu, glosář, styly, volba rozložení |
| `src/pages/` | Titulní strana, úvodní části, seznamy, draft, přílohy |
| `src/pages/internal/` | Konfigurace, validace, osoby, autorské pomůcky; `i18n/` (překlady, skloňování), `glossary/` (vstup, `#trm`, seznamy, pády) |
| `src/styling/` | Globální sazba, nadpisy, figury, přílohy, záhlaví, barvy, externí balíčky |
| `src/config.toml` | Laditelné hodnoty typografie |
| `template/` | Startovní projekt, který kopíruje `typst init` (licence MIT-0) |
| `tests/` | Testy přes veřejné rozhraní (skutečná PDF), testy distribuce a `snapshots/` (text každé strany profilů a ukázkové práce) |
| `examples/diplomka/` | Fiktivní diplomová práce s matematikou, chemií, grafy a kódem (kompiluje ji CI) |
| `scripts/ci.py` | Sestavení balíčku a kontrola všech profilů |

## Zásady

- **Nejmenší změna, která problém vyřeší celý.** Žádné nové volby ani závislosti „pro budoucnost“; nový balíček z Universe jen s jasným důvodem.
- **Nová logika má test** v `tests/` (větev, parser, validace, skloňování). Testuj přes veřejné rozhraní, jako stávající testy.
- **Sazba je ručně doladěná.** CI porovnává text každé strany sedmi profilů a ukázkové práce se snapshoty; změna, která nemá měnit PDF, musí projít beze změny snapshotů. Záměrnou změnu (`UPDATE_SNAPSHOTS=1`) popiš v PR, projdi diff snapshotů a přilož snímek před/po (`pdftoppm -r 100 -png`), protože snapshoty hlídají text a počet stran, ne vzhled.
- **Komentáře česky** a jen tam, kde vysvětlují *proč*. Zkratka se známým omezením dostane komentář, který omezení pojmenuje.
- **Veřejné API** (`src/lib.typ`, parametry `unob-thesis`, klíče `config.toml`) měň jen s aktualizací obou README a záznamem v [`CHANGELOG.md`](../CHANGELOG.md) v sekci `[Nevydáno]`.
- **Commity** v angličtině podle [Conventional Commits](https://www.conventionalcommits.org/): `fix:`, `feat:`, `docs:`, `refactor:`, `perf:`, `ci:`, `chore:`.

## Licence příspěvků

Příspěvky do `template/` (kromě fontů) se licencují pod MIT-0, vše ostatní pod AGPL-3.0-or-later — viz [`NOTICE`](../NOTICE). Loga Univerzity obrany neupravuj (viz tamtéž).

## Vydání

Správce po sloučení změní `package.version` v `typst.toml` a importy v `template/`, přesune záznamy z `[Nevydáno]` do nové verze a pushne tag `v<verze>`. Workflow **Typst release** vše znovu ověří a založí GitHub Release.
