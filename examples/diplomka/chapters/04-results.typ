#import "../../../src/lib.typ": first, flex-caption, landscape, plural, trm
#import "@preview/typsium:0.3.2": ce
#import "@preview/zero:0.7.1": num, quan, ztable
#import "@preview/cetz:0.5.2": canvas
#import "@preview/cetz-plot:0.1.4": plot
#import "@preview/subpar:0.2.2"
#import "@preview/physica:0.9.8": pdv
#import "../model.typ": *

= VÝSLEDKY A DISKUSE

Výsledky vznikly dosazením identifikovaných parametrů (tab. #rn(<tab:parametry>)) do modelu z kapitoly 1 a porovnáním s měřením z kapitoly 3. Všechna „měření" v grafech a tabulkách jsou fiktivní: body jsou vypočtené z modelu a doplněné deterministickou odchylkou ve velikosti jednotek milivoltů, aby se práce vysázela pokaždé stejně.

// Pomůcky pro grafy ---------------------------------------------------------------
#let cz(v, digits: 2) = [#str(calc.round(v, digits: digits)).replace(".", ",")]
#let colors = (rgb("#1f6f8b"), rgb("#c0392b"), rgb("#6c8a1e"), rgb("#8e44ad"), rgb("#d68910"))
#let dashes = ("solid", "dashed", "dotted", "dash-dotted", "solid")

/// Jedna větev grafu: modelová křivka + „naměřené" body každých ~12 minut.
#let discharge-curve(i, t-c, k, label) = {
  let t-end = t-cutoff(i, t-c)
  plot.add(domain: (0, t-end), samples: 90, x => u-term(x * 3600, i, t-c),
    label: label, style: (stroke: (paint: colors.at(k), dash: dashes.at(k), thickness: 1pt)))
  let step = calc.max(t-end / 8, 0.002)
  let pts = range(0, 9).map(j => {
    let x = calc.min(j * step, t-end)
    (x, u-term(x * 3600, i, t-c) + sum-noise(j + 7 * k + 3 * i))
  })
  plot.add(pts, style: (stroke: none), mark: "o", mark-size: 0.09,
    mark-style: (stroke: colors.at(k) + 0.8pt, fill: white))
}

== Vybíjecí křivky

Základní představu o chování článku dávají vybíjecí křivky na obrázku #rn(<obr:krivky>). Čím větší je proud, tím větší je okamžitý pokles napětí na odporech $R_0$ a $R_1$ a tím dříve se dosáhne koncového napětí #quan[3,0 V]. Teplota působí stejným směrem: při poklesu z #quan[25 °C] na #quan[0 °C] se odpory podle rovnice #rce(<eq:arrhenius>) zdvojnásobí, a navíc klesá využitelná kapacita.

#subpar.grid(
  figure(
    canvas(plot.plot(
      size: (5.2, 4.2), x-label: [$t$ (h)], y-label: [$U_"t"$ (V)],
      x-min: 0, x-max: 2.0, y-min: 2.8, y-max: 4.9, x-tick-step: 0.5, y-tick-step: 0.5,
      x-format: v => cz(v, digits: 1), y-format: v => cz(v, digits: 1),
      legend: "inner-north-east", legend-style: (item: (spacing: 0.12), padding: 0.08),
      {
        discharge-curve(1.51, 25, 0, [0,5C])
        discharge-curve(3.02, 25, 1, [1C])
        discharge-curve(4.53, 25, 2, [1,5C])
        discharge-curve(6.04, 25, 3, [2C])
      })),
    caption: [Vliv proudu při #quan[25 °C]],
  ), <obr:proud>,
  figure(
    canvas(plot.plot(
      size: (5.2, 4.2), x-label: [$t$ (h)], y-label: [$U_"t"$ (V)],
      x-min: 0, x-max: 1.0, y-min: 2.8, y-max: 4.9, x-tick-step: 0.25, y-tick-step: 0.5,
      x-format: v => cz(v), y-format: v => cz(v, digits: 1),
      legend: "inner-north-east", legend-style: (item: (spacing: 0.12), padding: 0.08),
      {
        discharge-curve(3.02, 45, 0, [45 °C])
        discharge-curve(3.02, 25, 1, [25 °C])
        discharge-curve(3.02, 0, 2, [0 °C])
        discharge-curve(3.02, -10, 3, [$-10$ °C])
        discharge-curve(3.02, -20, 4, [$-20$ °C])
      })),
    caption: [Vliv teploty při 1C],
  ), <obr:teplota>,
  columns: (1fr, 1fr),
  numbering: n => numbering("1.1", calc.max(counter(heading).get().first(), 1), n),
  numbering-sub-ref: (n, s) => numbering("1.1a", calc.max(counter(heading).get().first(), 1), n, s),
  caption: flex-caption(
    [Vybíjecí křivky svorkového napětí. Čáry jsou model, kroužky fiktivní měření. Zdroj: autor],
    [Vybíjecí křivky svorkového napětí],
  ),
  label: <obr:krivky>,
)

Z grafu b na obrázku #rn(<obr:krivky>) je vidět, že při #quan[-20 °C] a proudu 1C se koncového napětí dosáhne po necelých 20 minutách, tedy při využití necelé třetiny kapacity. To je pro polní nasazení zásadní zjištění.

== Teplotní závislost odporů

Identifikované odpory při jednotlivých teplotách shrnuje tabulka #rn(<tab:odpory>). Z hodnot je patrné, že odpor při #quan[-20 °C] je téměř čtyřikrát větší než při #quan[25 °C].

#block(breakable: false)[#figure(
  ztable(
    columns: 5,
    align: center,
    format: (none, auto, auto, auto, auto),
    [*Teplota (°C)*], [*$R_0$ (mΩ)*], [*$R_1$ (mΩ)*], [*$tau$ (s)*], [*$Q_"ef"$ (A·h)*],
    [-20], [142+-5], [79+-3], [142+-6], [2.27],
    [-10], [102+-3], [56+-2], [102+-4], [2.44],
    [0], [75+-2], [41+-2], [75+-3], [2.60],
    [25], [38+-1], [21+-1], [38+-2], [3.02],
    [45], [24+-1], [13+-1], [24+-1], [3.02],
  ),
  caption: [Identifikované parametry v závislosti na teplotě],
) <tab:odpory>]

Pro kontrolu Arrheniovy rovnice se logaritmus odporu vynáší proti převrácené hodnotě teploty (obr. #rn(<obr:arrhenius>)). Pokud rovnice platí, leží body na přímce se směrnicí $E_"a" slash R_g$. Přímka proložená body odpovídá aktivační energii #quan[18,4 kJ/mol], odchylky jednotlivých bodů zůstávají pod 3 %.

#figure(
  canvas(plot.plot(
    size: (8, 4.4), x-label: [$1000 slash T$ (K#super[−1])], y-label: [$ln(R_0 slash "mΩ")$],
    x-min: 3.0, x-max: 4.0, y-min: 3, y-max: 5.4, x-tick-step: 0.2, y-tick-step: 0.5,
    x-format: v => cz(v, digits: 1), y-format: v => cz(v, digits: 1),
    legend: "inner-north-west",
    {
      plot.add(domain: (3.05, 3.95), samples: 20,
        x => calc.ln(r0(1000 / x - 273.15) * 1000), label: [model],
        style: (stroke: (paint: colors.at(0), thickness: 1pt)))
      plot.add(
        ((-20, 0), (-10, 1), (0, 2), (25, 3), (45, 4)).map(((tc, j)) =>
          (1000 / (tc + 273.15), calc.ln(r0(tc) * 1000 * (1 + sum-noise(j + 11, amp: 0.2))))),
        style: (stroke: none), mark: "o", mark-size: 0.11,
        mark-style: (stroke: colors.at(1) + 0.9pt, fill: white), label: [měření])
    })),
  caption: flex-caption(
    [Arrheniův graf ohmického odporu. Zdroj: autor],
    [Arrheniův graf ohmického odporu],
  ),
) <obr:arrhenius>

== Ověření modelu

Model s parametry z tabulky #rn(<tab:odpory>) byl ověřen na deseti scénářích, které nebyly použity při identifikaci. Pro každý z nich se porovnala doba provozu do koncového napětí a střední kvadratická chyba napětí. Výsledky jsou v tabulce #rn(<tab:overeni>).

#let validation = (
  (-20, 1.51 * 2, 0.285, 0.291, 21), (-20, 1.51 * 4, 0.025, 0.023, 24),
  (-10, 1.51, 1.414, 1.402, 17), (-10, 1.51 * 3, 0.178, 0.181, 19),
  (0, 3.02, 0.648, 0.655, 14), (0, 6.04, 0.148, 0.145, 16),
  (25, 1.51, 1.945, 1.951, 9), (25, 4.53, 0.565, 0.562, 11),
  (45, 3.02, 0.963, 0.959, 8), (45, 6.04, 0.445, 0.448, 10),
)

#block(breakable: false)[#figure(
  ztable(
    columns: 5,
    align: center,
    format: (auto, auto, auto, auto, auto),
    [*$T$ (°C)*], [*$I$ (A)*], [*$t_"mod"$ (h)*], [*$t_"měř"$ (h)*], [*RMSE (mV)*],
    ..validation.map(((tc, i, tm, te, rmse)) => (
      [#tc], cz(i), cz(tm, digits: 3), cz(te, digits: 3), [#rmse],
    )).flatten(),
  ),
  caption: [Ověření modelu na scénářích mimo identifikační množinu],
) <tab:overeni>]

Průměrná střední kvadratická chyba přes všech deset scénářů je #quan[14,9 mV], největší #quan[24 mV] při #quan[-20 °C] a proudu 2C. Všechny hodnoty jsou pod stanovenou mezí #quan[30 mV], hypotéza z kapitoly 2 se tedy potvrdila. Chyba roste s klesající teplotou, protože při nízké teplotě se uplatňuje více jevů najednou (difuze v pevné fázi, přenos náboje, vznik #trm("SEI vrstva")) a jeden Arrheniův člen je nedokáže beze zbytku sjednotit.

Podrobný přehled všech scénářů, včetně vybité kapacity a odhadu přírůstku teploty, je v tabulce #rn(<tab:siroka>) na konci kapitoly.

== Citlivost na aktivační energii

Aktivační energie $E_"a"$ je v modelu jediný parametr, který převádí chování z referenční teploty na ostatní. Jeho vliv se proto hodí vyčíslit zvlášť. Relativní citlivost doby provozu $t$ na aktivační energii definuje podíl relativních změn:

$ S = (Delta t slash t) / (Delta E_"a" slash E_"a") approx E_"a" / t pdv(t, E_"a"). $ <eq:citlivost>

Doba provozu byla vypočtena pro tři hodnoty aktivační energie: identifikovanou a hodnoty o 20 % menší a větší. Z obrázku #rn(<obr:citlivost>) plyne, že při referenční teplotě #quan[25 °C] se doba provozu nemění, protože tam jsou odpory podle rovnice #rce(<eq:arrhenius>) rovny referenčním hodnotám. S klesající teplotou rozdíly narůstají a při #quan[-20 °C] jsou již velmi výrazné.

#figure(
  canvas(plot.plot(
    size: (8, 4.4), x-label: [$T$ (°C)], y-label: [$t$ (h)],
    x-min: -20, x-max: 45, y-min: 0, y-max: 1.2, x-tick-step: 10, y-tick-step: 0.2,
    x-format: v => cz(v, digits: 0), y-format: v => cz(v, digits: 1),
    legend: "inner-north-west",
    {
      for (k, (ea, lab)) in ((14720.0, [$E_"a" - 20$ %]), (18400.0, [$E_"a"$]), (22080.0, [$E_"a" + 20$ %])).enumerate() {
        plot.add(domain: (-20, 45), samples: 40, x => t-cutoff(3.02, x, ea: ea), label: lab,
          style: (stroke: (paint: colors.at(k), dash: dashes.at(k), thickness: 1pt)))
      }
    })),
  caption: flex-caption(
    [Doba provozu při proudu 1C v závislosti na teplotě pro tři hodnoty aktivační energie. Zdroj: autor],
    [Citlivost doby provozu na aktivační energii],
  ),
) <obr:citlivost>

Číselně shrnuje citlivost tabulka #rn(<tab:citlivost>). Při #quan[0 °C] změní odchylka aktivační energie o 20 % dobu provozu o desítky procent, při #quan[45 °C] jen o jednotky procent. Pro použití v zimě je proto přesná hodnota $E_"a"$ nejdůležitějším parametrem modelu a stojí za to ji ověřit samostatným měřením impedance.

#block(breakable: false)[#figure(
  table(
    columns: 4,
    align: center,
    table.header([*$T$ (°C)*], [*$E_"a" - 20$ %*], [*$E_"a"$*], [*$E_"a" + 20$ %*]),
    ..(-20, 0, 25, 45).map(tc => (
      [#tc],
      ..(14720.0, 18400.0, 22080.0).map(ea => cz(t-cutoff(3.02, tc, ea: ea), digits: 3)),
    )).flatten(),
  ),
  caption: [Doba provozu (h) při proudu 1C pro tři hodnoty aktivační energie],
) <tab:citlivost>]

== Tepelné chování

Při vybíjení se článek zahřívá. Pokud se použije zjednodušená bilance #rce(<eq:lump>), přírůstek teploty roste exponenciálně k ustálené hodnotě. Pro hmotnost #quan[46 g], měrnou tepelnou kapacitu #quan[1000 J/(kg K)] a součinitel $h A = quan("0,12 W/K")$ vychází časová konstanta zahřívání přibližně #quan[383 s]. Průběh přírůstku teploty pro čtyři proudy ukazuje obrázek #rn(<obr:zahrati>).

#figure(
  canvas(plot.plot(
    size: (8, 4.4), x-label: [$t$ (min)], y-label: [$Delta T$ (K)],
    x-min: 0, x-max: 30, y-min: 0, y-max: 20, x-tick-step: 5, y-tick-step: 5,
    legend: "inner-north-west",
    {
      for (k, (i, lab)) in ((1.51, [0,5C]), (3.02, [1C]), (4.53, [1,5C]), (6.04, [2C])).enumerate() {
        let q-heat = i * i * (r0(25) + r1(25))
        plot.add(domain: (0, 30), samples: 60,
          x => q-heat / 0.12 * (1 - calc.exp(-x * 60 / 383)), label: lab,
          style: (stroke: (paint: colors.at(k), dash: dashes.at(k), thickness: 1pt)))
      }
    })),
  caption: flex-caption(
    [Vypočtený přírůstek teploty povrchu článku při vybíjení při okolní teplotě #quan[25 °C]. Zdroj: autor],
    [Přírůstek teploty při vybíjení],
  ),
) <obr:zahrati>

Při proudu 2C se článek ustálí přibližně o #quan[17 K] nad okolím, ale vybití trvá jen asi #quan[27 min], a ustáleného stavu se tedy téměř dosáhne. Při nízké okolní teplotě je zahřívání výhodné: vyšší teplota snižuje odpor a tím i další ztráty, článek se částečně sám zahřívá. Entropický člen z rovnice #rce(<eq:bernardi>) je v tomto rozsahu zanedbatelný proti Jouleovu teplu, jak potvrzuje @bernardi1985[s. 8].

== Diskuse

Výsledky ukazují, že jednoduchý model je pro předpověď doby provozu dostačující, pokud se zná teplota článku. Použitelnost pro řízení baterie omezují tři věci:

- *Konstantní proud.* Parametry byly identifikovány při konstantním proudu. Skutečný odběr stanice je pulzní, a proto je nutné model ověřit i na pulzním zatížení.
- *Jedna aktivační energie.* Společná hodnota #quan[18,4 kJ/mol] pro $R_0$ i $R_1$ je zjednodušení. Oddělení obou hodnot by snížilo chybu při nízkých teplotách o jednotky milivoltů.
- *Stárnutí.* Parametry platí pro nový článek. S rostoucí tloušťkou vrstvy SEI odpor roste a model je třeba periodicky znovu identifikovat.

Z provozního hlediska vyplývají čtyři doporučení pro používání zdrojů v zimě. Zdroj je nutné uchovávat v teple, například pod oděvem, protože článek o #quan[20 K] teplejší má za jinak stejných podmínek čtyřikrát menší odpor. Pro nízké teploty je třeba počítat s využitelnou kapacitou jen 75 % jmenovité hodnoty. Zařízení s vyšším odběrem je vhodné napájet z více paralelních článků, aby se proud na článek snížil. A nabíjení za nízkých teplot se nemá provádět, protože hrozí pokovení anody kovovým lithiem podle reakce #ce("Li+ + e- -> Li(s)"), které trvale snižuje kapacitu a vytváří bezpečnostní riziko.

#landscape[
  #figure(
    ztable(
      columns: 9,
      align: center,
      format: (auto, auto, auto, auto, auto, auto, auto, auto, auto),
      [*$T$ (°C)*], [*$I$ (A)*], [*C-rate*], [*$t_"mod"$ (h)*], [*$t_"měř"$ (h)*], [*$Delta t$ (%)*], [*$Q_"vyb"$ (A·h)*], [*RMSE (mV)*], [*$Delta T_"max"$ (K)*],
      ..validation.map(((tc, i, tm, te, rmse)) => {
        let dt = (tm - te) / te * 100
        let qv = i * te
        let rise = calc.min(i * i * (r0(tc) + r1(tc)) / 0.12 * (1 - calc.exp(-te * 3600 / 383)), 40)
        (
          [#tc], cz(i), cz(i / 3.02, digits: 1), cz(tm, digits: 3), cz(te, digits: 3),
          cz(dt, digits: 1), cz(qv), [#rmse], cz(rise, digits: 1),
        )
      }).flatten(),
    ),
    caption: flex-caption(
      [Úplné výsledky ověřovacích scénářů. $Delta t$ je relativní odchylka doby provozu modelu od měření, $Delta T_"max"$ vypočtený přírůstek teploty povrchu. Zdroj: autor],
      [Úplné výsledky ověřovacích scénářů],
    ),
  ) <tab:siroka>
]
