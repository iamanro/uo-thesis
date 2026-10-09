// Tahák pro studenty: psaní závěrečné práce v Typstu místo ve Wordu.
// Sazba: typst compile --font-path template/fonts docs/tahak.typ

#let muted = rgb("#555555")
#let rule = rgb("#cccccc")
#let mono = "DejaVu Sans Mono"

#set document(title: "Závěrečná práce v Typstu: tahák", author: "unob-thesis")
#set page(paper: "a4", margin: (x: 20mm, y: 18mm), footer: context [
  #set text(size: 8pt, fill: muted)
  github.com/iamanro/uo-thesis #h(1fr) #counter(page).display() / #counter(page).final().first()
])
#set text(font: "TeX Gyre Termes", size: 11pt, lang: "cs")
#set par(justify: true, leading: 0.6em)
#show raw: set text(font: mono, size: 0.82em)
#show raw.where(block: false): box.with(fill: luma(240), inset: (x: 2pt), outset: (y: 2.5pt), radius: 1.5pt)
#show heading: it => block(above: 1.3em, below: 0.7em, text(size: 13pt, weight: "bold", it.body))
#set heading(numbering: none)

#let table-style = (
  stroke: (x, y) => if y == 0 { (bottom: 0.8pt) } else { (bottom: 0.4pt + rule) },
  inset: (x: 5pt, y: 4.5pt),
)

#text(size: 22pt, weight: "bold")[Závěrečná práce v Typstu místo ve Wordu] \
#text(fill: muted)[Pro studenty Univerzity obrany. Co je potřeba vědět, než si vyberete.]
#v(2pt)
#line(length: 100%, stroke: 0.8pt)

== O co jde

Typst je sázecí program, který z textových souborů vyrobí PDF. Šablona `unob-thesis` má hotovou titulní stranu, čestné prohlášení, abstrakty, seznamy, citace podle ČSN ISO 690 a přílohy, pro všechny fakulty a česky i anglicky. Píšete text, formát je daný.

== Co se ve Wordu dělá ručně a tady ne

- *Titulní strana a prohlášení* se vyplní z jednoho souboru `config.toml`. Jméno vedoucího ve 2. pádu se doplní samo, ruční tvar jde zadat.
- *Obsah, seznamy obrázků, tabulek a zkratek* se při každé kompilaci vytvoří znovu. Neaktualizují se pole.
- *Číslování* obrázků, tabulek a rovnic (`1.1`, v přílohách `A–1`) se počítá samo, odkaz v textu je `@klic`.
- *Literatura* je v souboru `references.bib`, v textu stačí `@novak2020`. Seznam zdrojů se vysází sám.
- *Zkratky a pojmy* jsou v `glossary.toml`, v textu se píše `#trm("iso")`.
- *Kontrola před odevzdáním* (`submit_check = true`) zastaví kompilaci, když zůstal ukázkový text, chybí abstrakt nebo zadání, má obrázek bez popisu nebo zbylo `#todo`.
- Archivní PDF/A vyrobí `typst compile --pdf-standard a-3b main.typ`. PDF/UA (přístupné) vyžaduje popis `alt` u každého obrázku i rovnice, u práce s matematikou je proto náročné.

== Co je jinak a co Typst neumí

- Výstupem je PDF, ne `.docx`. Vedoucímu se posílá PDF, komentovat se do něj dá běžným prohlížečem.
- Když vedoucí chce Word, jde PDF převést v Adobe Acrobatu (*Soubor › Exportovat do › Microsoft Word*) nebo online nástrojem Adobe „PDF do Wordu“. Výsledek je jen pro čtení a komentáře: obsah, čísla a odkazy v něm nejsou živá pole, tabulky a rovnice se často rozsypou a stránkování se liší. Práci dál pište v Typstu a po komentářích převod zopakujte.
- Text se píše se značkami (`= Nadpis`, `*tučně*`, `_kurzíva_`). Je to pár věcí, tabulka je na druhé straně. Chybová hláška ukáže soubor a řádek.
- Spolupráce více autorů na jednom textu funguje přes Git nebo sdílený projekt na typst.app, ne tak jako sledování změn ve Wordu.
- Šablona zatím není v oficiálním katalogu Typst Universe, instaluje se z GitHubu jako lokální balíček (krok 1 níže).

== Začít jde za pár minut

+ *Instalace.* Z #link("https://github.com/iamanro/uo-thesis/releases/latest")[Releases na GitHubu] stáhněte `unob-thesis-0.1.0.tar.gz` a rozbalte do složky lokálních balíčků Typstu. Cesty pro Linux, macOS a Windows jsou v README.
+ *Projekt.* `typst init @local/unob-thesis:0.1.0 moje-prace` vytvoří kostru s kapitolami, glosářem, seznamem literatury a fonty.
+ *Psaní.* Ve VS Code s rozšířením Tinymist otevřete `main.typ` a zapněte Preview, PDF se obnovuje při psaní. Bez instalace jde pracovat i na typst.app, tam je potřeba nahrát i složku `src/` (postup je v README).

#pagebreak()

== Word a Typst vedle sebe

#table(
  columns: (1fr, 2.4fr),
  ..table-style,
  table.header([*Ve Wordu*], [*V Typstu*]),
  [Nadpis kapitoly, podkapitoly], [`= Úvod`, `== Metody`, `=== Vzorek`],
  [Tučně, kurzíva], [`*důležité*`, `_termín_`],
  [Odrážky, číslovaný seznam], [`- položka`, `+ položka`],
  [Nový odstavec], [prázdný řádek],
  [Citace zdroje], [`@novak2020`, se stranou `@novak2020[s. 15]`],
  [Poznámka pod čarou], [`#footnote[Text poznámky.]`],
  [Obrázek s popiskem], [`#figure(image("graf.png"), caption: [Vývoj počtu]) <graf>`],
  [Tabulka], [`#figure(table(columns: 2, [A], [B], [1], [2]), caption: [Data])`],
  [Odkaz na obrázek], [`@graf` se vysází jako „Obrázek 2.1“],
  [Rovnice v textu, samostatně], [`$x^2$`, `$ E = m c^2 $`],
  [Zkratka], [poprvé `#trm("iso", style: first)`, dále `#trm("iso")`],
  [Poznámka pro sebe], [`#todo[doplnit zdroj]`, v odevzdané verzi není vidět],
)
#text(size: 9pt, fill: muted)[Funkce šablony (`trm`, `todo`, `flex-caption`) se v kapitole načtou řádkem `#import "@local/unob-thesis:0.1.0": trm, todo`. Ukázkové kapitoly ho mají.]

== Jak vypadá kapitola

#let sample = "== Výsledky

Měření proběhlo ve *třech* fázích:

- příprava vzorků,
- vlastní měření,
- vyhodnocení podle $F_1 = (2 P R) / (P + R)$.

Nejlepší výsledek dosáhla _konfigurace C_."
#grid(columns: (1fr, 1fr), column-gutter: 8pt, inset: 9pt, stroke: 0.6pt + rule,
  fill: (x, _) => if x == 0 { luma(247) },
  [
    #text(size: 8pt, fill: muted)[Soubor chapters/04-results.typ]
    #v(2pt)
    #raw(sample, lang: "typ", block: true)
  ],
  [
    #text(size: 8pt, fill: muted)[Výsledek v PDF]
    #v(2pt)
    #show heading: it => text(size: 11.5pt, weight: "bold")[4.2 #it.body]
    #eval(sample, mode: "markup")
  ],
)

== Časté otázky

#let qa(q, a) = block(breakable: false, below: 9pt)[*#q* \ #text(size: 10pt, a)]
#columns(2, gutter: 14pt)[
  #qa[Musím umět programovat?][Ne. Kostra práce (`main.typ`, `config.toml`) je hotová a běžně se neupravuje. Píše se do souborů v `chapters/`.]
  #qa[Musím něco instalovat?][Lokálně stačí Typst a VS Code s Tinymistem. Variantou je typst.app v prohlížeči.]
  #qa[Platí to pro moji fakultu a typ práce?][FVL, FVT, VLF i UO, práce bakalářské, diplomové a disertační, česky i anglicky.]
  #colbreak()
  #qa[Co když se něco rozbije?][Kompilátor napíše soubor, řádek a důvod. Překlep v klíči `config.toml` šablona pojmenuje. Chyby se hlásí v Issues na GitHubu.]
  #qa[Jak si práci zálohovat?][Kapitoly jsou obyčejné textové soubory, jdou do cloudu nebo do Gitu.]
  #qa[Kde je návod?][README v repozitáři, česky i anglicky: github.com/iamanro/uo-thesis]
]
