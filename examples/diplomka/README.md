# Ukázková diplomová práce

Fiktivní diplomová práce „Modelování vybíjení lithium-iontového článku pro přenosné komunikační prostředky“ (40 stran, z toho 19 stran textu). Všechny osoby, měření a výsledky jsou smyšlené, odkazy na literaturu jsou skutečné. Práce slouží k předvedení šablony a jako vstup regresních testů (`scripts/ci.py`).

```bash
# z kořene repozitáře
typst compile --root . --font-path template/fonts examples/diplomka/main.typ
```

| Soubor | Obsah |
|---|---|
| `main.typ` | Kostra práce; importuje šablonu přímo ze `src/` (v reálné práci `@local/unob-thesis:0.1.0`) |
| `config.toml` | Metadata, `submit_check = true`, `twoside = false` |
| `chapters/` | Úvod, teorie, cíl, metody, výsledky, závěr |
| `appendix.typ` | Přílohy A–C (odvození, kód grafů, údaje) |
| `model.typ` | Matematický model; funkce, ze kterých se kreslí grafy |
| `glossary.toml` | Zkratky, pojmy a symboly s jednotkami |
| `references.bib` | Literatura |
| `assets/` | Ukázkové skeny zadání (SVG s popisem `alt`) |

Co kde najdeš: chemické reakce a rovnice (`chapters/01-theory.typ`), schéma `fletcher` a výpisy kódu v Pythonu a Rustu (`chapters/03-methodology.typ`), grafy `cetz-plot`, podobrázky `subpar`, tabulky `zero` a stranu na šířku (`chapters/04-results.typ`), kód v příloze (`appendix.typ`).
