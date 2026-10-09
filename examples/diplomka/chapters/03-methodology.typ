#import "../../../src/lib.typ": first, flex-caption, trm
#import "@preview/physica:0.9.8": pdv
#import "@preview/zero:0.7.1": quan, ztable
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../model.typ": rce, rn

= POUŽITÉ METODY

== Měřicí soustava

Měření probíhalo na válcových článcích formátu 18650 s jmenovitou kapacitou přibližně #quan[3 A h]. Článek byl upnut v teplotní komoře a vybíjen programovatelnou elektronickou zátěží v režimu konstantního proudu. Svorkové napětí a teplotu povrchu zaznamenával vícekanálový záznamník s vzorkovací periodou #quan[1 s]; řídicí počítač nastavoval teplotu komory a proud zátěže a ukládal data (obr. #rn(<obr:soustava>)).

#figure(
  diagram(
    node-stroke: 0.7pt,
    node-inset: 7pt,
    spacing: (22mm, 12mm),
    node((0, 0), [Řídicí počítač], name: <pc>),
    node((1, -0.6), [Programovatelná \ zátěž], name: <load>),
    node((1, 0.6), [Záznamník \ $U$, $T$], name: <daq>),
    node((2, 0), [Článek 18650], name: <cell>, shape: fletcher.shapes.rect, fill: rgb("#eef2e0")),
    node(enclose: (<cell>,), stroke: (dash: "dashed", paint: gray), inset: 14pt, name: <chamber>, snap: false),
    node((2, 1.3), text(size: 0.8em)[teplotní komora], stroke: none),
    edge(<pc>, <load>, "->", [$I_"nastav"$], label-side: left),
    edge(<pc>, <daq>, "<-", [data]),
    edge(<load>, <cell>, "<->", [$I$]),
    edge(<daq>, <cell>, "<-", [$U_"t"$, $T$]),
  ),
  caption: flex-caption(
    [Blokové schéma měřicí soustavy. Zdroj: autor],
    [Schéma měřicí soustavy],
  ),
) <obr:soustava>

Přístroje byly před měřením ověřeny na etalonech. Nejistota měření napětí byla #quan[2 mV], proudu #quan[5 mA] a teploty #quan[0,3 K].

== Plán měření

Vybíjení probíhalo z plného nabití (napětí #quan[4,2 V]) do koncového napětí #quan[3,0 V] při pěti teplotách a čtyřech proudech. Polovina scénářů sloužila k identifikaci parametrů, druhá polovina k nezávislému ověření (tab. #rn(<tab:plan>)).

#block(breakable: false)[#figure(
  table(
    columns: 5,
    align: (left, center, center, center, center),
    table.header([*Teplota*], [*0,5C*], [*1C*], [*1,5C*], [*2C*]),
    [$-20$ °C], [I], [V], [I], [V],
    [$-10$ °C], [V], [I], [V], [I],
    [$0$ °C], [I], [V], [I], [V],
    [$25$ °C], [V], [I], [V], [I],
    [$45$ °C], [I], [V], [I], [V],
  ),
  caption: [Plán měření: I = identifikace, V = ověření (1C odpovídá proudu #quan[3 A])],
) <tab:plan>]

Střídavé rozdělení scénářů zajišťuje, aby ověřovací scénáře ležely mezi identifikačními a model tak nebyl hodnocen jen na datech, ze kterých vznikl.

== Parametry modelu

Parametry modelu se rozdělují na ty, které se přebírají z datového listu, a ty, které se identifikují. Přehled s odhadnutými hodnotami při referenční teplotě #quan[25 °C] uvádí tabulka #rn(<tab:parametry>).

#block(breakable: false)[#figure(
  ztable(
    columns: 4,
    align: (left, left, right, left),
    format: (none, none, auto, none),
    [*Veličina*], [*Značka*], [*Hodnota*], [*Jednotka*],
    [Kapacita], [$Q$], [3.02+-0.02], [A·h],
    [Napětí naprázdno, koeficient], [$a_0$], [3.12], [V],
    [], [$a_1$], [1.10], [V],
    [], [$a_2$], [-0.90], [V],
    [], [$a_3$], [0.88], [V],
    [], [$a_4$], [0.12], [V],
    [Ohmický odpor], [$R_0$], [38+-1], [mΩ],
    [Polarizační odpor], [$R_1$], [21+-1], [mΩ],
    [Polarizační kapacita], [$C_1$], [1800+-90], [F],
    [Aktivační energie], [$E_"a"$], [18.4+-0.6], [kJ·mol#super[−1]],
  ),
  caption: [Parametry modelu při 25 °C],
) <tab:parametry>]

== Identifikace parametrů

Neznámý vektor parametrů $bold(theta) = (R_0, R_1, E_"a")$ se hledá metodou nejmenších čtverců. Minimalizuje se součet druhých mocnin rozdílů mezi změřeným a modelovým napětím přes všechny vzorky identifikačních scénářů:

$ hat(bold(theta)) = arg min_bold(theta) sum_(k=1)^N [U_"mer,k" - U_"t" (t_k; bold(theta))]^2 . $ <eq:lsq>

Úloha je nelineární v parametru $E_"a"$, proto se řeší iterativně metodou Levenbergovou–Marquardtovou. Ukázku výpočtu v jazyce Python uvádí výpis #rn(<lst:fit>).

#figure(
  ```python
  import numpy as np
  from scipy.optimize import least_squares

  RG, T_REF = 8.314, 298.15

  def arrhenius(t_c, e_a):
      return np.exp(e_a / RG * (1 / (t_c + 273.15) - 1 / T_REF))

  def residuals(theta, scenarios):
      r0, r1, e_a = theta
      out = []
      for sc in scenarios:
          model = u_model(sc["t"], sc["i"], sc["t_c"], r0, r1, e_a)
          out.append(sc["u"] - model)
      return np.concatenate(out)

  fit = least_squares(residuals, x0=[0.04, 0.02, 15e3],
                      args=(identification_set,), method="lm")
  print(fit.x)  # R0, R1, Ea
  ```,
  caption: [Identifikace parametrů metodou nejmenších čtverců (Python)],
) <lst:fit>

== Numerické řešení

Pro proměnný proud se soustava rovnic #rce(<eq:model>) řeší numericky. Použita je metoda Runge–Kutta čtvrtého řádu @press2007, která pro krok $h$ počítá

$ bold(y)_(n+1) = bold(y)_n + h/6 (bold(k)_1 + 2 bold(k)_2 + 2 bold(k)_3 + bold(k)_4), $ <eq:rk4>

kde $bold(y) = (s, U_1)^T$ a pomocné vektory jsou $bold(k)_1 = bold(f)(t_n, bold(y)_n)$, $bold(k)_2 = bold(f)(t_n + h/2, bold(y)_n + h/2 bold(k)_1)$, $bold(k)_3 = bold(f)(t_n + h/2, bold(y)_n + h/2 bold(k)_2)$ a $bold(k)_4 = bold(f)(t_n + h, bold(y)_n + h bold(k)_3)$. Lokální chyba metody je řádu $cal(O)(h^5)$. Při kroku $h = quan("1 s")$ a časové konstantě $tau$ v desítkách sekund je chyba zanedbatelná proti nejistotě měření.

Postup výpočtu jednoho scénáře se skládá z těchto kroků:

+ nastavit počáteční stav $s = 1$, $U_1 = 0$ a načíst teplotu $T$,
+ spočítat odpory $R_0(T)$ a $R_1(T)$ podle rovnice #rce(<eq:arrhenius>),
+ provést krok #rce(<eq:rk4>) pro aktuální proud,
+ spočítat svorkové napětí z poslední rovnice soustavy #rce(<eq:model>),
+ opakovat, dokud napětí neklesne pod #quan[3,0 V].

Implementace v jazyce Python je v výpisu #rn(<lst:rk4>), vestavěná varianta pro mikrokontrolér v jazyce Rust v výpisu #rn(<lst:rust>).

#figure(
  ```python
  def rk4_step(f, t, y, h):
      k1 = f(t, y)
      k2 = f(t + h / 2, y + h / 2 * k1)
      k3 = f(t + h / 2, y + h / 2 * k2)
      k4 = f(t + h, y + h * k3)
      return y + h / 6 * (k1 + 2 * k2 + 2 * k3 + k4)

  def simulate(i, t_c, h=1.0, q=3.02, c1=1800.0):
      r0, r1 = r0_of(t_c), r1_of(t_c)
      f = lambda t, y: np.array([-i / (3600 * q), -y[1] / (r1 * c1) + i / c1])
      t, y, out = 0.0, np.array([1.0, 0.0]), []
      while True:
          u = uoc(y[0]) - i * r0 - y[1]
          if u < 3.0:
              return np.array(out)
          out.append((t, u))
          y, t = rk4_step(f, t, y, h), t + h
  ```,
  caption: [Řešení modelu metodou Runge–Kutta (Python)],
) <lst:rk4>

#figure(
  ```rust
  /// Jeden krok modelu (explicitní Euler, dostačuje při kroku do 1 s).
  pub fn step(state: &mut State, i: f32, p: &Params, h: f32) -> f32 {
      state.soc -= i * h / (3600.0 * p.q);
      state.u1 += h * (-state.u1 / (p.r1 * p.c1) + i / p.c1);
      uoc(state.soc) - i * p.r0 - state.u1
  }
  ```,
  caption: [Krok modelu pro mikrokontrolér (Rust)],
) <lst:rust>

== Nejistota výsledků

Standardní nejistota odvozené veličiny $y = f(x_1, dots, x_n)$ se z nejistot vstupů určuje zákonem šíření nejistot:

$ u(y) = sqrt(sum_(i=1)^n (pdv(f, x_i))^2 u^2(x_i)), $ <eq:nejistota>

za předpokladu nekorelovaných vstupů. Pro kapacitu $Q = I t$ vychází relativní nejistota ze součtu čtverců relativních nejistot proudu a času. Při proudu #quan[3 A] s nejistotou #quan[5 mA] a čase #quan[3,6e3 s] s nejistotou #quan[0,5 s] činí relativní nejistota kapacity 0,17 %, což odpovídá absolutní nejistotě pod #quan[0,01 A h]. Skutečná nejistota kapacity v tabulce #rn(<tab:parametry>) je větší, protože zahrnuje i opakovatelnost měření mezi články a vliv teploty.
