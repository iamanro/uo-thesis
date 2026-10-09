# Bezpečnostní politika

*English: report vulnerabilities privately via [Report a vulnerability](https://github.com/iamanro/uo-thesis/security/advisories/new), never in a public issue. Only the latest release is supported.*

## Podporované verze

Opravy dostává jen poslední vydaná verze (aktuálně řada `0.1.x`).

## Jak nahlásit zranitelnost

Zranitelnost nahlas **soukromě** přes [Report a vulnerability](https://github.com/iamanro/uo-thesis/security/advisories/new) — nezakládej veřejné issue. Uveď, čeho se problém týká, jak ho zopakovat a jaký může mít dopad.

Do rozsahu patří zejména:

- workflow v `.github/workflows/` (oprávnění, únik tokenu, podvržení artefaktu),
- integrita distribučního archivu a `SHA256SUMS` ve vydáních,
- kód šablony, který by při sazbě četl nebo vkládal data mimo projekt práce.

Na hlášení odpovíme co nejdříve a opravu vydáme jako novou verzi s poznámkou v `CHANGELOG.md`.
