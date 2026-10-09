// Tahák pro studenty: proč psát závěrečnou práci v Typstu místo ve Wordu.
// Sazba: typst compile --font-path template/fonts docs/tahak.typ

#let ink = rgb("#0f172a")
#let muted = rgb("#475569")
#let line-color = rgb("#e2e8f0")
#let faculty = (rgb("#808205"), rgb("#6188cd"), rgb("#ea0738"), rgb("#fec820"))
#let mono = "DejaVu Sans Mono"

#set document(title: "Diplomka v Typstu, ne ve Wordu — tahák", author: "unob-thesis")
#set page(paper: "a4", margin: (x: 16mm, top: 14mm, bottom: 14mm), footer: context [
  #set text(size: 8pt, fill: muted)
  github.com/iamanro/uo-thesis #h(1fr) Tento tahák je vysázený v Typstu — zdroj `docs/tahak.typ` #h(1fr) #counter(page).display() / #counter(page).final().first()
])
#set text(font: "TeX Gyre Termes", size: 10.5pt, lang: "cs", fill: ink)
#set par(justify: true, leading: 0.55em)
#show raw: set text(font: mono, size: 0.85em)
#show raw.where(block: false): box.with(fill: rgb("#f1f5f9"), inset: (x: 2.5pt, y: 0pt), outset: (y: 2.5pt), radius: 2pt)

#let stripe = stack(dir: ltr, ..faculty.map(c => rect(width: 25%, height: 4pt, fill: c)))
#let section(title) = {
  v(9pt)
  text(size: 15pt, weight: "bold", title)
  v(-4pt)
  line(length: 100%, stroke: 0.6pt + line-color)
  v(1pt)
}
#let card(color, title, body) = block(
  width: 100%, inset: (left: 9pt, rest: 7pt), radius: (right: 4pt),
  stroke: (left: 3pt + color), fill: color.lighten(92%),
)[#text(weight: "bold", size: 11pt, title) \ #text(size: 9.5pt, body)]

// ─────────────────────────── 1. strana ───────────────────────────

#block(width: 100%, fill: ink, inset: (x: 16pt, top: 14pt, bottom: 0pt), radius: 6pt, clip: true)[
  #text(font: mono, size: 8.5pt, fill: faculty.at(3), tracking: 1.5pt)[TAHÁK · UNIVERZITA OBRANY]
  #v(2pt)
  #text(size: 27pt, weight: "bold", fill: white)[Diplomka v Typstu, ne ve Wordu]
  #v(-6pt)
  #text(size: 12pt, fill: rgb("#cbd5e1"))[Ty píšeš text. O titulní stranu, okraje, číslování, seznamy a citace se postará šablona.]
  #v(8pt)
  #move(dx: -16pt, box(width: 100% + 32pt, stripe))
]

#section[Proč Typst a šablona `unob-thesis`]

#grid(columns: (1fr, 1fr), gutter: 7pt,
  card(faculty.at(0))[Formátování řeší šablona][Titulní strana, čestné prohlášení, okraje, písmo a číslování podle pravidel UO. Ty vyplníš `config.toml` a píšeš.],
  card(faculty.at(1))[Nic se nerozjede][Obsah, seznamy obrázků, tabulek a zkratek, čísla stran i odkazy se přepočítají samy po každé změně.],
  card(faculty.at(2))[Citace podle ČSN ISO 690][Zdroje dáš do `references.bib`, v textu napíšeš `@klic`. Seznam literatury se vysází sám.],
  card(faculty.at(3).darken(25%))[Kontrola před odevzdáním][`submit_check` odmítne ukázkový text, chybějící abstrakt či zadání, obrázky bez popisu a zapomenutá `#todo`.],
  card(faculty.at(0))[Náhled hned, jak píšeš][Editor zobrazuje hotové PDF průběžně vedle textu. Žádné „aktualizovat pole“ před tiskem.],
  card(faculty.at(1))[Zdarma a bez rizika][Open source, v prohlížeči i offline. Text je v obyčejných souborech — žádný poškozený `.docx`, verze klidně v Gitu.],
)

#section[Word vs. Typst — poctivě]

#table(
  columns: (1.15fr, 1.5fr, 1.6fr),
  stroke: (x, y) => if y == 0 { (bottom: 0.8pt + ink) } else { (bottom: 0.4pt + line-color) },
  inset: (x: 5pt, y: 4.5pt),
  table.header([*Úkol*], [*Word*], [*Typst + šablona*]),
  [Titulní strana, prohlášení], [Přepsat ze vzoru, hlídat tvary jmen], [Vznikne z `config.toml`, jméno vedoucího sám vyskloňuje],
  [Obsah a seznamy], [Funguje, ale je třeba aktualizovat pole a styly], [Vždy aktuální, při každé kompilaci],
  [Číslování obrázků a rovnic], [Titulky a pole, snadno se rozpadnou], [Automaticky, `1.1` v kapitolách, `A–1` v přílohách],
  [Citace], [Doplněk nebo ruční přepis], [`@klic` + `references.bib`, styl ISO 690],
  [Zkratky], [Seznam udržovat ručně], [`glossary.toml`, v textu `#trm("iso")`],
  [Velká práce (100+ stran)], [Zpomalí se, formát se snadno rozbije], [Pořád jen textové soubory po kapitolách],
  [Archivní PDF], [Export s volbou PDF/A], [`--pdf-standard a-3b` (+ PDF/UA)],
)

#section[Začni za 5 minut]

#grid(columns: (1fr, 1fr, 1fr), gutter: 8pt,
  ..(
    ([1], [Nainstaluj šablonu], [Stáhni archiv z *Releases* na GitHubu a rozbal ho do složky lokálních balíčků Typstu — návod je v README.]),
    ([2], [Založ projekt], [`typst init @local/unob-thesis:0.1.0 moje-prace` — vznikne kostra s kapitolami, glosářem a fonty.]),
    ([3], [Piš], [VS Code + rozšíření *Tinymist* → otevři `main.typ` → *Preview*. Nebo vše v prohlížeči na *typst.app*.]),
  ).map(((n, title, body)) => block(width: 100%, inset: 8pt, radius: 4pt, stroke: 0.6pt + line-color)[
    #box(fill: ink, radius: 50%, inset: (x: 5.5pt, y: 3pt), text(fill: white, weight: "bold", n)) #h(3pt) *#title*
    #v(-2pt)
    #text(size: 9.5pt, body)
  ])
)

// ─────────────────────────── 2. strana ───────────────────────────

#pagebreak()

#section[Co děláš ve Wordu → co napíšeš v Typstu]

#let nebo = h(4pt) + text(fill: muted)[nebo] + h(4pt)
#table(
  columns: (1fr, 2.3fr),
  stroke: (x, y) => if y == 0 { (bottom: 0.8pt + ink) } else { (bottom: 0.4pt + line-color) },
  inset: (x: 5pt, y: 4.5pt),
  table.header([*Ve Wordu*], [*V Typstu napíšeš*]),
  [Kapitola / podkapitola], [`= Úvod` #nebo `== Metody` #nebo `=== Vzorek`],
  [Tučně / kurzíva], [`*důležité*` #nebo `_termín_`],
  [Odrážky / číslovaný seznam], [`- položka` #nebo `+ položka`],
  [Nový odstavec], [prázdný řádek],
  [Citace zdroje], [`@novak2020` #nebo `@novak2020[s. 15]` (se stranou)],
  [Poznámka pod čarou], [`#footnote[Text poznámky.]`],
  [Obrázek s popiskem], [`#figure(image("graf.png"), caption: [Vývoj počtu]) <graf>`],
  [Tabulka], [`#figure(table(columns: 2, [A], [B], [1], [2]), caption: [Data])`],
  [Křížový odkaz], [`@graf` → „Obrázek 2.1“ (číslo se dopočítá samo)],
  [Rovnice v textu / samostatně], [`$x^2$` #nebo `$ E = m c^2 $`],
  [Zkratka], [`#trm("iso", style: first)` poprvé, dál `#trm("iso")`],
  [Poznámka pro sebe], [`#todo[doplnit zdroj]` — vidět jen v pracovní verzi],
)
#text(size: 9pt, fill: muted)[Funkce šablony si kapitola načte prvním řádkem: `#import "@local/unob-thesis:0.1.0": trm, todo` (ukázkové kapitoly ho už mají).]

#section[Celá kapitola vypadá takhle]

#let sample = "== Výsledky

Měření proběhlo ve *třech* fázích:

- příprava vzorků,
- vlastní měření,
- vyhodnocení podle $F_1 = (2 P R) / (P + R)$.

Nejlepší výsledek dosáhla _konfigurace C_."
#grid(columns: (1fr, 1fr), column-gutter: 8pt, inset: 9pt, stroke: 0.6pt + line-color,
  fill: (x, _) => if x == 0 { rgb("#f8fafc") },
  [
    #text(font: mono, size: 7.5pt, fill: muted, tracking: 1pt)[PÍŠEŠ — chapters/04-results.typ]
    #v(2pt)
    #raw(sample, lang: "typ", block: true)
  ],
  [
    #text(font: mono, size: 7.5pt, fill: muted, tracking: 1pt)[VIDÍŠ — v PDF]
    #v(2pt)
    #set heading(numbering: (..n) => "4.2")
    #show heading: set text(size: 11.5pt)
    #eval(sample, mode: "markup")
  ],
)

#section[Časté obavy]

#let qa(q, a) = block(breakable: false, below: 10pt)[*„#q“* \ #text(size: 9.5pt, a)]
#columns(2, gutter: 12pt)[
  #qa[Neumím programovat.][Nepotřebuješ. Píšeš text jako v poznámkách a formátování je pár značek z tabulky výše. Kostru (`main.typ`, `config.toml`) máš hotovou a běžně ji neměníš.]
  #qa[Musím něco instalovat?][Ne. Webová aplikace *typst.app* běží v prohlížeči (jeden krok navíc je v README). Lokálně stačí VS Code s rozšířením Tinymist.]
  #qa[Sedí to na moji fakultu?][Titulní strana, prohlášení i okraje pro FVL, FVT, VLF a UO; bakalářská, diplomová i disertační práce; česky i anglicky.]
  #colbreak()
  #qa[Vedoucí chce Word.][Typst vytváří PDF, ne `.docx`. Posílej PDF — komentáře jdou psát přímo do něj v každém prohlížeči PDF. Pokud vedoucí `.docx` opravdu vyžaduje, domluv se s ním dřív, než začneš psát.]
  #qa[Co když se něco rozbije?][Chyba ukáže soubor, řádek a důvod; překlep v `config.toml` šablona ohlásí jménem klíče. Rady a hlášení chyb: Issues na GitHubu.]
  #qa[Nepřijdu o text?][Kapitoly jsou obyčejné textové soubory — zálohuj je do cloudu nebo Gitu. Žádný jeden velký soubor, který se může poškodit.]
]

#v(1fr)
#block(width: 100%, fill: ink, inset: (x: 16pt, y: 12pt), radius: 6pt)[
  #set text(fill: white)
  #text(size: 14pt, weight: "bold")[Zkus to hned — první stránku vysázíš do pěti minut.]
  #v(-4pt)
  #text(size: 10pt, fill: rgb("#cbd5e1"))[Šablona, návod pro VS Code i webovou aplikaci a hlášení chyb: #text(font: mono, size: 9pt, fill: faculty.at(3))[github.com/iamanro/uo-thesis]]
]
