#import "../../../src/lib.typ": trm
#import "@preview/zero:0.7.1": quan

Práce vytvořila a ověřila model vybíjení lithium-iontového článku formátu 18650 pro přenosné komunikační prostředky. Z elektrochemických dějů na elektrodách byl odvozen náhradní obvod s ohmickým odporem a jednou polarizační větví, jehož odpory se řídí Arrheniovou rovnicí. Model byl doplněn o tepelnou bilanci a řešen numericky metodou Runge–Kutta čtvrtého řádu.

Dílčí cíle se podařilo splnit. Model byl odvozen (C1), parametry byly identifikovány z vybíjecích měření při pěti teplotách a čtyřech proudech (C2) a na deseti nezávislých scénářích dosáhla střední kvadratická chyba napětí #trm("rmse") průměrně 14,9 mV, nejvýše 24 mV (C3). Pracovní hypotéza z kapitoly 2 se potvrdila: jedna aktivační energie postačuje k předpovědi napětí s chybou pod 30 mV v rozsahu od $-20$ do $45$ °C.

Nejdůležitějším praktickým zjištěním je prudký pokles využitelné kapacity za nízkých teplot. Při #quan[-20 °C] a proudu 1C využije článek necelou třetinu kapacity, při proudu 2C se koncové napětí dosáhne za necelé dvě minuty. Doporučení pro provoz (C4) proto zahrnují udržování zdrojů v teple, počítání s kapacitou kolem 75 % jmenovité hodnoty a nenabíjení za mrazu.

Další práce by měla model ověřit na pulzním zatížení typickém pro rádiové stanice, oddělit aktivační energie jednotlivých odporů a doplnit stárnutí. Model je dostatečně jednoduchý, aby se vešel do mikrokontroléru systému řízení baterie.

