/*
Pravidla skloňování převzata z https://github.com/davidmalasek/sklonovani-jmen
(původně Python, zde přepsáno do Typstu).

MIT License

Copyright (c) 2024 David Malášek

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// Koho, čeho? — 2. pád jednoho slova jména, malými písmeny. Indexuje se po
// znacích (codepoints), ne po bajtech, kvůli diakritice.
#let _genitiv-slova(slovo) = {
  let w = lower(slovo).codepoints()
  let n = w.len()
  let j = w.join(default: "")
  if n < 2 or w.last() == "." { return j } // iniciála („J.") nebo zkratka — neskloňujeme
  let (c1, c2) = (w.at(-1), w.at(-2))
  let c3 = if n >= 3 { w.at(-3) } else { "" }
  let bez(k) = w.slice(0, n - k).join(default: "") // slovo bez posledních k znaků

  if c1 == "a" {
    if c2 in ("č", "j", "ď", "c") { bez(1) + "i" } // Ivča, Kája, Láďa, Danica
    else if c2 == "i" { bez(1) + "e" } // Olivia
    else if c2 == "o" { j } // Figueroa
    else if c2 == "ň" { bez(2) + "ni" } // Soňa
    else if c2 in ("e", "š") and c3 != "c" { bez(1) + if c3 == "r" { "ji" } else { "i" } } // Andrea, Nataša, Lea
    else { bez(1) + "y" } // Anna, Olga, Eliška, Pavla, Klára, Eva, Tereza, Průcha
  } else if c1 == "á" {
    bez(1) + "é"
  } else if c1 == "e" {
    if c2 in ("g", "e", "o", "i", "c", "š") { j } else { bez(1) + "i" } // George, Lee, Zoe, Lucie, Alice, Danuše
  } else if c1 in ("h", "i") {
    if c2 == "c" { j + "a" } else { j } // Bedřich, Vojtěch / Sarah, Niki
  } else if c1 == "k" {
    if c2 == "e" { bez(2) + "ka" } // Malášek
    else if c2 == "ě" and n >= 3 {
      if c3 == "n" { bez(3) + "ňka" } // Zbyněk, Vaněk
      else if c3 == "d" { bez(3) + "ďka" } // Luděk
      else { j } // jiné „-ěk": raději nezměněné než chybný tvar
    } else { j + "a" } // Novák
  } else if c1 == "l" {
    if c2 == "e" { if c3 in ("c", "i", "u") { j + "a" } else { bez(2) + "la" } } // Marcel, Samuel, Gabriel / Karel
    else if c2 == "o" and c3 == "k" { j } // Nikol
    else if c2 in ("a", "i", "o", "s") { j + "a" } // Michal, Bohumil, Anatol, Přemysl
    else { j + "e" } // Král
  } else if c1 == "m" {
    if c2 == "a" { j } else { j + "a" } // Miriam / Maxim
  } else if c1 == "o" {
    if c2 == "t" { bez(1) + "y" } else { bez(1) + "a" } // Oto / Ronaldo, Santiago
  } else if c1 == "r" {
    if c2 in ("a", "e") { if c3 in ("k", "m", "p", "l") { j + "a" } else { j } } // Otakar, Otmar, Kašpar / Dagmar, Ester
    else { j + "a" }
  } else if c1 in ("y", "í", "é") {
    if c2 == "l" { j } else { j + "ho" } // Emily / Harry, Jiří, René
  } else if c1 == "ý" {
    bez(1) + "ého"
  } else if c1 == "d" {
    if j in ("ingrid", "astrid", "sigrid") { j } else { j + "a" } // nesklonná ženská / David, Richard
  } else if c1 == "c" {
    if c2 in ("n", "l") { j + "e" } else { bez(2) + "ce" } // Vincenc, Šolc / Vavřinec
  } else if c1 == "t" {
    if j in ("rút", "růt", "margaret") { j } else { j + "a" } // nesklonná ženská / Vít, Robert
  } else if c1 == "ů" {
    j // Petrů
  } else if c1 in ("ž", "j", "ř", "š", "x", "s") {
    j + "e" // Tomáš, Ondřej, Max, Nikolas
  } else {
    j + "a"
  }
}

// Velké počáteční písmeno každé části (i u dvojitých příjmení: Novák-Šmíd).
#let _kapitalizace(slovo) = {
  slovo
    .split("-")
    .map(cast => {
      let znaky = cast.codepoints()
      if znaky.len() == 0 { "" } else { upper(znaky.first()) + znaky.slice(1).join(default: "") }
    })
    .join("-")
}

// Funkce: genitiv
// Co: 2. pád jména či příjmení (i víceslovného): „Jana Nováková" → „Jany Novákové".
#let genitiv(value) = value.split(" ").map(slovo => _kapitalizace(_genitiv-slova(slovo))).join(" ")
