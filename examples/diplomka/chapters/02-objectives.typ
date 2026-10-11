#import "../../../src/lib.typ": first, trm

#import "../model.typ": rn, rce

= CÍL A OMEZENÍ PRÁCE

== Cíl práce

Cílem práce je navrhnout, identifikovat a ověřit model vybíjení lithium-iontového článku, který s dostatečnou přesností předpovídá svorkové napětí a dobu provozu přenosné komunikační stanice při proudech a teplotách odpovídajících polnímu nasazení. Dílčí cíle jsou:

+ *C1:* odvodit náhradní obvod s teplotně závislými parametry z elektrochemických dějů popsaných v kapitole 1,
+ *C2:* identifikovat parametry modelu z vybíjecích měření při různých proudech a teplotách,
+ *C3:* ověřit model na scénářích, které nebyly použity při identifikaci, a vyhodnotit chybu předpovědi,
+ *C4:* formulovat doporučení pro provoz zdrojů za nízkých teplot.

Splnění cíle se posuzuje podle střední kvadratické chyby (#trm("rmse", style: first)) svorkového napětí na ověřovací množině. Jako přijatelná mez byla stanovena hodnota 30 mV, což odpovídá rozlišení měření napětí v systému řízení baterie.

== Hypotéza

Pracovní hypotéza zní: _model s jednou polarizační větví, jehož odpory se řídí Arrheniovou rovnicí s jedinou aktivační energií, popíše vybíjení v rozsahu teplot od_ $-20$ _do_ $45$ °C _s chybou menší než_ 30 mV. Hypotéza je záměrně jednoduchá. Kdyby se potvrdila, bylo by možné model implementovat i na jednoduchém mikrokontroléru.

== Omezení práce

Práce se omezuje na vybíjení konstantním proudem a na jeden typ článku. Neřeší stárnutí, nabíjení ani bezpečnostní scénáře (zkrat, mechanické poškození). Požadavky, ze kterých vychází volba rozsahu, shrnuje tabulka #rn(<tab:pozadavky>).

#block(breakable: false)[#figure(
  table(
    columns: (auto, 1fr, auto),
    align: (center, left, left),
    table.header([*Označení*], [*Požadavek*], [*Zdroj*]),
    [P1], [Provoz při teplotě od $-20$ do $45$ °C], [provozní podmínky],
    [P2], [Vybíjecí proud do 2C (6 A)], [odběr vysílače],
    [P3], [Chyba předpovědi napětí do 30 mV], [rozlišení BMS],
    [P4], [Výpočet v reálném čase na mikrokontroléru], [vestavěné řešení],
  ),
  caption: [Požadavky na model a jejich zdroj],
) <tab:pozadavky>]

Požadavek P4 vylučuje plné elektrochemické modely, jejichž řešení soustavy parciálních diferenciálních rovnic se v zařízení nevejde do časového rozpočtu. Zvolený náhradní obvod vyžaduje výpočet jedné diferenciální rovnice na krok a několika elementárních funkcí.
