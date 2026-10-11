// Matematický model článku — funkce, ze kterých se kreslí grafy v kapitolách.
// Hodnoty parametrů odpovídají tabulce v kapitole 3 (fiktivní).

#let q-nom = 3.02          // jmenovitá kapacita, A·h
#let r0-ref = 0.038        // ohmický odpor při 25 °C, Ω
#let r1-ref = 0.021        // polarizační odpor při 25 °C, Ω
#let c1 = 1800.0           // polarizační kapacita, F (na teplotě nezávisí)
#let e-a = 18400.0         // aktivační energie, J/mol
#let gas-r = 8.314         // molární plynová konstanta, J/(mol·K)
#let t-ref = 298.15        // referenční teplota, K

/// Napětí naprázdno v závislosti na stavu nabití s ∈ ⟨0; 1⟩, V.
#let uoc(s) = 3.12 + 1.1 * s - 0.9 * calc.pow(s, 2) + 0.88 * calc.pow(s, 3) - 0.12 * calc.exp(-25 * s)

/// Arrheniův faktor: násobek odporu při teplotě `t-c` (°C) vůči 25 °C.
#let arrhenius(t-c, ea: e-a) = calc.exp(ea / gas-r * (1 / (t-c + 273.15) - 1 / t-ref))

#let r0(t-c, ea: e-a) = r0-ref * arrhenius(t-c, ea: ea)
#let r1(t-c, ea: e-a) = r1-ref * arrhenius(t-c, ea: ea)

/// Využitelná kapacita při nízkých teplotách (empirický lineární pokles), A·h.
#let q-eff(t-c) = q-nom * (1 - 0.0055 * calc.max(0, 25 - t-c))

/// Svorkové napětí při konstantním proudu `i` (A) po čase `t` (s) a teplotě `t-c` (°C).
/// Analytické řešení modelu s jednou polarizační větví.
#let u-term(t, i, t-c, ea: e-a) = {
  let s = 1 - i * t / (3600 * q-eff(t-c))
  let tau = r1(t-c, ea: ea) * c1  // časová konstanta R₁C₁, s
  uoc(calc.max(s, 0)) - i * r0(t-c, ea: ea) - i * r1(t-c, ea: ea) * (1 - calc.exp(-t / tau))
}

/// Doba do dosažení koncového napětí 3,0 V, hodiny (hledání půlením intervalu).
#let t-cutoff(i, t-c, u-min: 3.0, ea: e-a) = {
  let (lo, hi) = (0.0, 3600 * q-eff(t-c) / i)
  for _ in range(40) {
    let mid = (lo + hi) / 2
    if u-term(mid, i, t-c, ea: ea) > u-min { lo = mid } else { hi = mid }
  }
  lo / 3600
}

/// Pseudonáhodná odchylka „měření" od modelu (deterministická, aby se práce vysázela vždy stejně).
#let sum-noise(k, amp: 0.012) = amp * calc.sin(k * 12.9898) * calc.cos(k * 4.1414)

/// Odkaz na rovnici jen číslem v závorce, např. „(1.4)“ (bez slova „Rovnice“).
#let rce(label) = ref(label, supplement: none)

/// Odkaz jen číslem (bez slova „Tabulka", „Obrázek"), aby šlo slovo v textu správně skloňovat.
#let rn(label) = ref(label, supplement: none)
