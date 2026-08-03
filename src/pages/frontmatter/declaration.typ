#import "../../styling/packages.typ": ez-today
#import "../internal/i18n/index.typ": t, thesis-type-is-bachelor-or-master
#import "../../styling/styles.typ": frontmatter-heading
#import "../internal/people.typ": format-name, format-supervisor-for-declaration
#import "../internal/localization.typ": get-city-name, get-faculty-name, get-thesis-type-name

// Funkce: _gendered
// Účel: Vrátí `male_form` nebo `female_form` podle pohlaví autora.
// Pro `sex: none` použije mužský tvar (shodně s titulní stranou).
#let _gendered(sex, male_form, female_form) = if sex == "F" { female_form } else { male_form }

// Funkce: render-declaration
// Účel: Vykreslí čestné prohlášení vždy v českém jazyce.
#let render-declaration(
  config,
  lang: "cs",
) = {
  let declaration = config.declaration
  let author = config.author
  let supervisor = config.supervisor
  let university = config.university
  let thesis = config.thesis
  let thesis_type = variant => text(lang: "cs")[#get-thesis-type-name(
    thesis.type,
    variant: variant,
    lang: "cs",
  )]
  let supervisor_role = if thesis-type-is-bachelor-or-master(thesis.type) {
    _gendered(supervisor.sex, [vedoucího práce], [vedoucí práce])
  } else {
    _gendered(supervisor.sex, [školitele], [školitelky])
  }

  context if declaration.declaration != false {
    frontmatter-heading(t("declaration", lang: lang))

    [
      Prohlašuji, že jsem zadanou #thesis_type(3)
      na téma #emph[#thesis.title] #_gendered(author.sex, [vypracoval], [vypracovala]) samostatně, pod odborným vedením
      #supervisor_role
      #format-supervisor-for-declaration(supervisor) a~#_gendered(author.sex, [použil], [použila]) jsem pouze literární zdroje uvedené v práci.

      #parbreak()

      Dále prohlašuji, že při vytváření této práce jsem
      #if declaration.ai_used != false {
        _gendered(author.sex, [použil], [použila])
        [
          nástroje umělé inteligence. Tyto nástroje byly využity v souladu s platnými obecně závaznými právními předpisy, vnitřními předpisy
          Univerzity obrany#if university.faculty != "uo" [ a #text(lang: "cs")[#get-faculty-name(university.faculty, variant: 2, lang: "cs")]]
          a etickými normami.
        ]
      } else {
        _gendered(author.sex, [nepoužil], [nepoužila])
        [ nástroje umělé inteligence. ]
      }

      #parbreak()

      Dále prohlašuji, že jsem
      #_gendered(author.sex, [seznámen], [seznámena])
      s tím, že se na moji #thesis_type(3)
      vztahují práva a~povinnosti vyplývající ze zákona č. 121/2000 Sb., o právu autorském,
      o právech souvisejících s právem autorským a o změně některých zákonů
      (autorský zákon), ve znění pozdějších předpisů, zejména skutečnosti,
      že Univerzita obrany má právo na uzavření licenční smlouvy o užití
      této #thesis_type(2)
      jako školního díla
      podle §~60~odst.~1 výše uvedeného zákona, a s tím, že pokud dojde k
      užití této #thesis_type(2)
      mnou nebo
      bude poskytnuta licence o užití díla třetímu subjektu, je Univerzita
      obrany oprávněna ode mne požadovat přiměřený příspěvek na úhradu
      nákladů, které na vytvoření díla vynaložila, a~to~podle okolností až
      do jejich skutečné výše.

      #parbreak()

      Souhlasím se zpřístupněním své
      #thesis_type(2)
      pro prezenční studium v prostorách knihovny Univerzity obrany.

      #v(2cm)
      #align(center, grid(
        align: (left, center),
        columns: (50%, 50%),
        rows: 2,
        [
          V #get-city-name(university.faculty, variant: 2, lang: "cs"),
          dne #lower[#ez-today.today(lang: "cs", format: "d. m. Y")]
        ],
        [#box(width: 1fr, repeat[.])],

        v(.5cm), [],
        [], [#format-name(author)],
      ))
    ]
  }
}

