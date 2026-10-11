#import "../../src/lib.typ": flex-caption
#import "@preview/cetz:0.5.2": canvas
#import "@preview/cetz-plot:0.1.4": plot
#import "@preview/zero:0.7.1": num
#import "@preview/physica:0.9.8": dv
#import "model.typ": *

= ODVOZENÍ ANALYTICKÉHO ŘEŠENÍ

Pro konstantní proud $I$ lze soustavu z kapitoly 1 vyřešit v uzavřeném tvaru. První rovnice dává lineární pokles stavu nabití, druhá je lineární rovnice prvního řádu pro polarizační napětí $U_1$.

== Stav nabití

Integrací rovnice $dv(s, t) = - I slash (3600 Q)$ s počáteční podmínkou $s(0) = s_0$ vychází

$ s(t) = s_0 - (I t) / (3600 Q). $ <eq:ap-soc>

== Polarizační napětí

Rovnici $dv(U_1, t) + U_1 slash tau = I slash C_1$, kde $tau = R_1 C_1$, vynásobíme integračním faktorem $e^(t slash tau)$:

$ dv(, t) (U_1 e^(t slash tau)) = I / C_1 e^(t slash tau). $ <eq:ap-integral>

Integrací od nuly do $t$ s podmínkou $U_1(0) = 0$ a úpravou dostaneme

$ U_1(t) = I R_1 (1 - e^(-t slash tau)). $ <eq:ap-u1>

Dosazením do poslední rovnice soustavy vychází svorkové napětí v uzavřeném tvaru, které se používá pro grafy v kapitole 4:

$ U_"t" (t) = U_"oc" (s(t)) - I R_0 - I R_1 (1 - e^(-t slash tau)). $ <eq:ap-ut>

= ZDROJOVÝ KÓD GRAFŮ

Grafy v práci se kreslí přímo v Typstu funkcemi ze souboru `model.typ`. Výpis ukazuje jejich jádro, tedy napětí naprázdno, Arrheniův faktor a analytické svorkové napětí (výpis #rn(<lst:model>)).

#figure(
  ```typ
  #let uoc(s) = 3.12 + 1.1 * s - 0.9 * calc.pow(s, 2)
    + 0.88 * calc.pow(s, 3) - 0.12 * calc.exp(-25 * s)

  #let arrhenius(t-c) = calc.exp(
    e-a / gas-r * (1 / (t-c + 273.15) - 1 / t-ref))

  #let u-term(t, i, t-c) = {
    let s = 1 - i * t / (3600 * q-eff(t-c))
    let tau = r1(t-c) * c1
    uoc(calc.max(s, 0)) - i * r0(t-c)
      - i * r1(t-c) * (1 - calc.exp(-t / tau))
  }
  ```,
  caption: [Jádro modelu v Typstu],
) <lst:model>

= POMOCNÉ ÚDAJE

Obrázek ukazuje použitou závislost napětí naprázdno na stavu nabití podle rovnice z kapitoly 1; tabulka uvádí její hodnoty po desetinách.

#figure(
  canvas(plot.plot(
    size: (7, 4), x-label: [$s$ (1)], y-label: [$U_"oc"$ (V)],
    x-min: 0, x-max: 1, y-min: 2.9, y-max: 4.3, x-tick-step: 0.2, y-tick-step: 0.2,
    {
      plot.add(domain: (0, 1), samples: 80, uoc, style: (stroke: (paint: rgb("#1f6f8b"), thickness: 1pt)))
    })),
  caption: [Napětí naprázdno v závislosti na stavu nabití],
) <obr:ap-uoc>

#figure(
  table(
    columns: 6,
    align: center,
    [*$s$*], ..range(0, 5).map(j => num(j * 0.2)),
    [*$U_"oc"$ (V)*], ..range(0, 5).map(j => num(uoc(j * 0.2), digits: 3)),
  ),
  caption: [Napětí naprázdno po dvou desetinách stavu nabití],
) <tab:ap-uoc>
