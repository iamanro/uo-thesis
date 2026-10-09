## Co a proč / What and why

<!-- Co se mění a proč. Odkaz na issue: "Closes #123". -->

## Dopad na sazbu / Effect on the PDF

<!-- Mění se vysázené PDF? Přilož snímek před/po, nebo napiš „beze změny". -->

## Kontrola / Checklist

- [ ] `python3 -m unittest discover -s tests -v` prochází
- [ ] `python3 scripts/ci.py check --output <prázdná složka>` prochází (bez varování kompilátoru)
- [ ] Nová logika (větev, parser, validace) má test v `tests/`
- [ ] Záznam v `CHANGELOG.md` v sekci `[Nevydáno]`
- [ ] README (česky i anglicky) odpovídá změně veřejného API nebo chování
