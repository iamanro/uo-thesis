#import "../../../src/lib.typ": first, flex-caption, plural, trm
#import "@preview/typsium:0.3.2": ce
#import "@preview/physica:0.9.8": pdv, dv, grad, div, laplacian
#import "@preview/zero:0.7.1": quan
#import "@preview/cetz:0.5.2": canvas, draw
#import "../model.typ": rce, rn

= TEORETICKÁ ČÁST

== Lithium-iontový článek

Článek typu #trm("li_ion", style: first) se skládá ze dvou porézních elektrod nasycených elektrolytem a oddělených porézním separátorem. Záporná elektroda (anoda při vybíjení) je z grafitu, kladná (katoda) z oxidu kovu, v našem případě z oxidu lithno-kobaltitého. Lithium se mezi elektrodami přenáší jako ion Li#super[+] a na elektrodách se vratně ukládá procesem zvaným #trm("interkalace"). Podrobný přehled principů uvádějí Goodenough a Park @goodenough2013, matematické základy Newman a Thomas-Alyea @newman2004.

Při vybíjení probíhají na elektrodách tyto poloreakce:

$ #ce("LiCoO2 <=> Li_(1-x)CoO2 + x Li+ + x e-") quad "(katoda, dolů při nabíjení)" $ <eq:katoda>

$ #ce("x Li+ + x e- + 6C <=> Li_(x)C6") quad "(anoda, nahoru při nabíjení)" $ <eq:anoda>

Celková reakce vznikne součtem rovnic #rce(<eq:katoda>) a #rce(<eq:anoda>) a má tvar
#ce("LiCoO2 + 6C <=> Li_(1-x)CoO2 + Li_(x)C6"). Šipka vpravo odpovídá nabíjení, vlevo vybíjení. Parametr $x$ je stupeň interkalace na anodě a s přesností na konstantní faktor odpovídá odebranému náboji.

Při prvním nabití se na grafitu vytvoří tzv. #trm("SEI vrstva"). Spotřebuje část lithia, a proto je kapacita nového článku o několik procent menší než teoretická. Vrstva s časem roste a zvyšuje vnitřní odpor, což je hlavní příčina stárnutí článku.

== Termodynamika a napětí naprázdno

Napětí článku v rovnováze, tedy bez protékajícího proudu, určuje změna Gibbsovy energie reakce:

$ Delta G = - n F E, $ <eq:gibbs>

kde $n$ je počet vyměněných elektronů, $F$ Faradayova konstanta a $E$ rovnovážné napětí. Závislost na složení popisuje Nernstova rovnice

$ E = E^circle.small - (R_g T) / (n F) ln Q_r, $ <eq:nernst>

kde $R_g$ je molární plynová konstanta, $T$ termodynamická teplota a $Q_r$ reakční kvocient. U lithium-iontového článku je $Q_r$ funkcí stupně interkalace obou elektrod, a proto napětí naprázdno $U_"oc"$ plynule klesá s odebraným nábojem. V praxi se zapisuje jako tabulka nebo empirický polynom stavu nabití $s$. Tato práce používá polynom s exponenciálním členem, který popisuje strmý pokles těsně před vybitím:

$ U_"oc" (s) = a_0 + a_1 s + a_2 s^2 + a_3 s^3 - a_4 e^(-25 s). $ <eq:uoc>

Koeficienty $a_0 = quan("3,12 V")$ až $a_4 = quan("0,12 V")$ jsou uvedeny v tabulce v kapitole 3. Pro zkratku #trm("ocv") se v textu používá index "oc". Stav nabití #trm("soc", style: first) se definuje vztahem

$ s(t) = s_0 - 1/(3600 Q) integral_0^t I(tau) dif tau, $ <eq:soc>

kde $Q$ je kapacita v ampérhodinách, $I$ proud (kladný při vybíjení) a faktor 3600 převádí ampérhodiny na coulomby.

== Kinetika a difuze

Rychlost elektrochemické reakce na rozhraní elektrody a elektrolytu popisuje Butlerova–Volmerova rovnice:

$ j = j_0 [exp((alpha_a F eta) / (R_g T)) - exp(-(alpha_c F eta) / (R_g T))], $ <eq:bv>

kde $j$ je proudová hustota, $j_0$ výměnná proudová hustota, $alpha_a$ a $alpha_c$ koeficienty přenosu náboje a $eta$ přepětí, tedy rozdíl mezi skutečným a rovnovážným potenciálem elektrody. Pro malá přepětí se rovnice linearizuje a dává ekvivalent odporu přenosu náboje, který se v náhradním obvodu objeví jako součást polarizačního odporu.

Pohyb lithia uvnitř zrn aktivního materiálu je řízen difuzí. Za předpokladu kulových částic o poloměru $r_p$ platí Fickův zákon ve sférických souřadnicích:

$ pdv(c, t) = D / r^2 pdv(, r) (r^2 pdv(c, r)), $ <eq:fick>

s okrajovými podmínkami

$ cases(
  pdv(c, r) = 0 & "pro" r = 0 "(symetrie)",
  -D pdv(c, r) = j / F & "pro" r = r_p "(tok na povrchu)"
). $ <eq:fick-bc>

Výpočetně náročné řešení rovnic #rce(<eq:fick>) a #rce(<eq:fick-bc>) pro tisíce částic se v modelech pro řízení baterií nahrazuje obvodovými prvky. Plný elektrochemický model v duchu práce Doyla, Fullera a Newmana @doyle1993 zůstává referenčním řešením, se kterým se zjednodušené modely porovnávají.

Teplotní závislost transportních a kinetických veličin se standardně popisuje Arrheniovou rovnicí:

$ X(T) = X_"ref" exp[E_"a" / R_g (1/T - 1/T_"ref")], $ <eq:arrhenius>

kde $X$ je veličina (odpor, difuzivita), $E_"a"$ aktivační energie a $T_"ref" = quan("298,15 K")$ referenční teplota. Čím větší je aktivační energie, tím strměji roste odpor s klesající teplotou.

== Tepelná bilance

Teplo uvolněné při vybíjení má dva zdroje: nevratné ztráty na vnitřním odporu a vratné entropické teplo reakce. Bernardi, Pawlikowski a Newman @bernardi1985 je shrnuli ve vztahu

$ dot(q) = I (U_"oc" - U_"t") - I T dv(U_"oc", T), $ <eq:bernardi>

kde $dot(q)$ je výkon uvolněného tepla a $U_"t"$ svorkové napětí. První člen je vždy kladný, druhý mění znaménko podle stavu nabití. Rozložení teploty v článku popisuje rovnice vedení tepla se zdrojem:

$ rho c_p pdv(T, t) = div (k grad T) + dot(q)/V, $ <eq:teplo>

kde $rho$ je hustota, $c_p$ měrná tepelná kapacita, $k$ tepelná vodivost a $V$ objem článku. Pro malý článek s dobrým prostupem tepla ve válci se teplota po objemu téměř nemění a rovnici lze zjednodušit na bilanci jedné teploty:

$ m c_p dv(T, t) = dot(q) - h A (T - T_"okolí"), $ <eq:lump>

s hmotností $m$, součinitelem přestupu tepla $h$ a povrchem $A$. Pro ustálený stav a konstantní výkon dává rovnice #rce(<eq:lump>) přírůstek teploty $Delta T = dot(q) / (h A)$. Pokud teplotu vypočteme, je zpětná vazba do odporu dána vztahem #rce(<eq:arrhenius>).

== Náhradní obvod

Pro praktické použití v systému řízení baterie (#trm("bms", style: first)) se článek nahrazuje elektrickým obvodem (obr. #rn(<obr:obvod>)). Obvod obsahuje zdroj napětí naprázdno $U_"oc" (s)$, ohmický odpor $R_0$ a jednu polarizační větev $R_1 C_1$, která popisuje přechodové děje difuze a přenosu náboje.

#figure(
  canvas(length: 1cm, {
    import draw: *
    set-style(stroke: 0.8pt)
    // zdroj
    line((0, 0), (0, 0.6))
    line((-0.45, 0.6), (0.45, 0.6))
    line((-0.25, 0.9), (0.25, 0.9), stroke: 2pt)
    line((0, 0.9), (0, 2))
    content((-0.9, 0.75), $U_"oc"$)
    // vodič k R0
    line((0, 2), (1.2, 2))
    rect((1.2, 1.8), (2.4, 2.2), fill: white)
    content((1.8, 2.55), $R_0$)
    line((2.4, 2), (3.4, 2))
    // polarizační větev R1 || C1
    line((3.4, 2), (3.4, 2.7))
    line((3.4, 2.7), (4.0, 2.7))
    rect((4.0, 2.5), (5.0, 2.9), fill: white)
    content((4.5, 3.25), $R_1$)
    line((5.0, 2.7), (5.6, 2.7))
    line((3.4, 2), (3.4, 1.3))
    line((3.4, 1.3), (4.1, 1.3))
    line((4.1, 1.05), (4.1, 1.55))
    line((4.5, 1.05), (4.5, 1.55))
    line((4.5, 1.3), (5.6, 1.3))
    content((4.3, 0.7), $C_1$)
    line((5.6, 2.7), (5.6, 1.3))
    line((5.6, 2), (6.6, 2))
    circle((6.6, 2), radius: 0.07, fill: black)
    content((7.1, 2), $U_"t"$)
    // zpětný vodič
    line((0, 0), (6.6, 0))
    circle((6.6, 0), radius: 0.07, fill: black)
    // proud
    line((0.3, 2.35), (1.0, 2.35), mark: (end: ">"))
    content((0.65, 2.65), $I$)
  }),
  caption: flex-caption(
    [Náhradní obvod článku s jednou polarizační větví. Zdroj: autor, podle @plett2015],
    [Náhradní obvod článku],
  ),
) <obr:obvod>

Obvod popisuje soustava obyčejných diferenciálních rovnic (#trm("ode", style: first)). Stav nabití $s$ klesá úměrně proudu, polarizační napětí $U_1$ na kondenzátoru $C_1$ se vyrovnává s časovou konstantou $tau = R_1 C_1$ a svorkové napětí je dáno Kirchhoffovým zákonem pro napětí:

$ cases(
  dv(s, t) = - I / (3600 Q),
  dv(U_1, t) = - U_1 / (R_1 C_1) + I / C_1,
  U_"t" = U_"oc"(s) - I R_0 - U_1 .
) $ <eq:model>

Pro konstantní proud $I$ má soustava rovnic #rce(<eq:model>) analytické řešení. Stav nabití klesá lineárně a polarizační napětí se přibližuje ustálené hodnotě exponenciálně:

$ U_1(t) = I R_1 (1 - e^(-t slash tau)). $ <eq:u1>

Při proměnném proudu, který odpovídá skutečnému provozu rádiové stanice (střídání příjmu a vysílání), řešení analytické není a soustava se řeší numericky, jak je popsáno v kapitole 3.
