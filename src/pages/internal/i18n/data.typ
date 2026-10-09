// Data: Překlady řetězců a statické tabulky pro i18n moduly.
#let translations = (
  "title_page": (cs: [TITULNÍ LIST], en: [TITLE PAGE]),
  "assignment_placement": (cs: [Zde patří zadání.], en: [Assignment placement]),
  "acknowledgement": (cs: [PODĚKOVÁNÍ], en: [ACKNOWLEDGEMENT]),
  "declaration": (cs: [ČESTNÉ PROHLÁŠENÍ], en: [DECLARATION]),
  "toc": (cs: [OBSAH], en: [TABLE OF CONTENTS]),
  "list_acronyms": (cs: [SEZNAM ZKRATEK], en: [LIST OF ACRONYMS]),
  "list_terms": (cs: [SEZNAM POJMŮ], en: [LIST OF TERMS]),
  "list_figures": (cs: [SEZNAM OBRÁZKŮ], en: [LIST OF FIGURES]),
  "list_tables": (cs: [SEZNAM TABULEK], en: [LIST OF TABLES]),
  "list_equations": (cs: [SEZNAM ROVNIC], en: [LIST OF EQUATIONS]),
  "list_listings": (cs: [SEZNAM VÝPISŮ], en: [LIST OF LISTINGS]),
  "list_symbols": (cs: [SEZNAM SYMBOLŮ], en: [LIST OF SYMBOLS]),
  "introduction": (cs: [ÚVOD], en: [INTRODUCTION]),
  "conclusion": (cs: [ZÁVĚR], en: [CONCLUSION]),
  "list_appendices": (cs: [SEZNAM PŘÍLOH], en: [LIST OF APPENDICES]),
  "appendix": (cs: [PŘÍLOHA], en: [APPENDIX]),
  "university_name": (cs: [Univerzita obrany], en: [University of Defence]),
  "programme_label": (cs: [Studijní program: ], en: [Programme: ]),
  "specialisation_label": (cs: [Studijní specializace: ], en: [Specialisation: ]),
  // Doktorské studium nemá „specializaci", ale „zaměření studia".
  "specialisation_label_doctoral": (cs: [Zaměření studia: ], en: [Field of Study: ]),
  "author_male": (cs: [Zpracoval:], en: [Author:]),
  "author_female": (cs: [Zpracovala:], en: [Author:]),
  "supervisor_work_label": (cs: [Vedoucí práce:], en: [Supervisor:]),
  "supervisor_label": (cs: [Školitel:], en: [Supervisor:]),
  "advisor_label": (cs: [Odborný konzultant:], en: [Advisor:]),
  "co_supervisor_label": (cs: [Školitel-specialista:], en: [Co-Supervisor:]),
  "error_draft_bool": (
    cs: "Parametr `draft` musí být typu bool (`true` nebo `false`).",
    en: "`draft` must be a bool (`true` or `false`).",
  ),
  "error_title_required": (
    cs: "Parametr `thesis.title` nesmí být prázdný.",
    en: "`thesis.title` must not be empty.",
  ),
  "error_author_required": (
    cs: "Autor musí mít vyplněné alespoň jméno nebo příjmení.",
    en: "Author must have at least a name or surname.",
  ),
  "error_person_sex": (
    cs: "Hodnota `person.sex` musí být `M`, `F` nebo `none`.",
    en: "`person.sex` must be `M`, `F`, or `none`.",
  ),
  "person_role_author": (cs: "Autor", en: "Author"),
  "person_role_supervisor": (cs: "Vedoucí / školitel", en: "Supervisor"),
  "person_role_first_advisor": (cs: "Odborný konzultant", en: "Advisor"),
  "person_role_second_advisor": (cs: "Školitel-specialista", en: "Co-supervisor"),
  "error_person_name_required": (
    cs: "Parametr `person.name` musí být neprázdný řetězec.",
    en: "`person.name` must be a non-empty string.",
  ),
  "error_person_surname_required": (
    cs: "Parametr `person.surname` musí být neprázdný řetězec.",
    en: "`person.surname` must be a non-empty string.",
  ),
  "error_person_prefix_type": (
    cs: "Parametr `person.prefix` musí být řetězec nebo `none`.",
    en: "`person.prefix` must be a string or `none`.",
  ),
  "error_person_suffix_type": (
    cs: "Parametr `person.suffix` musí být řetězec nebo `none`.",
    en: "`person.suffix` must be a string or `none`.",
  ),
  "error_person_genitive_type": (
    cs: "Parametr `person.genitive` musí být řetězec nebo `none`.",
    en: "`person.genitive` must be a string or `none`.",
  ),
  "error_supervisor_required_for_declaration": (
    cs: "Při zapnutém prohlášení je nutné vyplnit vedoucího/školitele.",
    en: "When declaration is enabled, supervisor must be provided.",
  ),
  "error_outlines_acronyms_requires_dictionary": (
    cs: "Pro seznam zkratek (`outlines.acronyms`) musí být `acronyms` slovník.",
    en: "For acronym list (`outlines.acronyms`), `acronyms` must be a dictionary.",
  ),
  "error_outlines_terms_requires_dictionary": (
    cs: "Pro glosář pojmů (`outlines.terms`) musí být `terms` slovník.",
    en: "For glossary of terms (`outlines.terms`), `terms` must be a dictionary.",
  ),
  "error_outlines_type": (
    cs: "Parametr `outlines` musí být slovník (`dictionary`) nebo `false`.",
    en: "`outlines` must be a dictionary or `false`.",
  ),
  "error_theme_type": (
    cs: "Parametr `theme` musí být slovník (`dictionary`) nebo `false`.",
    en: "`theme` must be a dictionary or `false`.",
  ),
  "error_twoside_bool": (
    cs: "Parametr `twoside` musí být typu bool (`true` nebo `false`).",
    en: "`twoside` must be a bool (`true` or `false`).",
  ),
  "error_declaration_bool": (
    cs: "Hodnoty v `declaration` musí být typu bool.",
    en: "`declaration` values must be bool.",
  ),
  "error_assignment_content": (
    cs: "`assignment_front` a `assignment_back` musí být `none` nebo obsah Typstu, například `image(...)`.",
    en: "`assignment_front` and `assignment_back` must be `none` or Typst content, for example `image(...)`.",
  ),
  "error_submit_check_bool": (
    cs: "`submit_check` musí být typu bool.",
    en: "`submit_check` must be bool.",
  ),
  "error_submit_check_draft_disabled": (
    cs: "Při `submit_check: true` musí být `draft: false`.",
    en: "With `submit_check: true`, `draft` must be `false`.",
  ),
  "error_submit_check_supervisor_required": (
    cs: "Při `submit_check: true` musí být vyplněn vedoucí/školitel.",
    en: "With `submit_check: true`, supervisor must be provided.",
  ),
  "error_submit_check_abstract_cs_required": (
    cs: "Při `submit_check: true` musí být vyplněn český abstrakt (`abstract.czech`).",
    en: "With `submit_check: true`, Czech abstract (`abstract.czech`) is required.",
  ),
  "error_submit_check_abstract_en_required": (
    cs: "Při `submit_check: true` musí být vyplněn anglický abstrakt (`abstract.english`).",
    en: "With `submit_check: true`, English abstract (`abstract.english`) is required.",
  ),
  "error_submit_check_keywords_cs_required": (
    cs: "Při `submit_check: true` musí být vyplněna česká klíčová slova (`keywords.czech`).",
    en: "With `submit_check: true`, Czech keywords (`keywords.czech`) are required.",
  ),
  "error_submit_check_keywords_en_required": (
    cs: "Při `submit_check: true` musí být vyplněna anglická klíčová slova (`keywords.english`).",
    en: "With `submit_check: true`, English keywords (`keywords.english`) are required.",
  ),
  "error_submit_check_introduction_required": (
    cs: "Při `submit_check: true` musí být vyplněn `introduction`.",
    en: "With `submit_check: true`, `introduction` must be provided.",
  ),
  "error_submit_check_bibliography_required": (
    cs: "Při `submit_check: true` musí být vyplněna bibliografie.",
    en: "With `submit_check: true`, bibliography must be provided.",
  ),
  "error_bibliography_type": (
    cs: "Parametr `bibliography` musí být `none`, hodnota `bibliography(...)`, nebo pole takových hodnot. Nepředávejte cestu jako řetězec — např. `bibliography: bibliography(\"references.bib\", style: \"iso-690-numeric\")`.",
    en: "The `bibliography` parameter must be `none`, a `bibliography(...)` value, or an array of such values. Do not pass a path string — e.g. `bibliography: bibliography(\"references.bib\", style: \"iso-690-numeric\")`.",
  ),
  "error_submit_check_assignment_required": (
    cs: "Při `submit_check: true` musí být vložen líc i rub zadání práce.",
    en: "With `submit_check: true`, both assignment pages must be provided.",
  ),
  "error_submit_check_image_alt": (
    cs: "Při `submit_check: true` musí mít každý vložený obrázek `alt` text (PDF/UA). Doplňte `alt` u obrázků bez popisu — např. `image(\"zadani.png\", alt: \"Zadání práce\")`. Obrázky bez `alt`:",
    en: "With `submit_check: true`, every inserted image must have `alt` text (PDF/UA). Add `alt` to images without a description — e.g. `image(\"assignment.png\", alt: \"Thesis assignment\")`. Images without `alt`:",
  ),
  "error_submit_check_title_sample": (
    cs: "Název práce je stále ukázkový („Název práce“). Vyplňte skutečný název (`thesis.title`).",
    en: "The thesis title is still the template sample (\"Název práce\"). Fill in the real title (`thesis.title`).",
  ),
  "error_submit_check_author_sample": (
    cs: "Autor je stále ukázkový („Jan Novák“). Vyplňte skutečné jméno a příjmení autora.",
    en: "The author is still the template sample (\"Jan Novák\"). Fill in the real author name and surname.",
  ),
  "error_submit_check_abstract_cs_sample": (
    cs: "Český abstrakt je stále ukázkový („Český abstrakt práce.“). Napište vlastní abstrakt (`abstract.czech`).",
    en: "The Czech abstract is still the template sample (\"Český abstrakt práce.\"). Write your own abstract (`abstract.czech`).",
  ),
  "error_submit_check_abstract_en_sample": (
    cs: "Anglický abstrakt je stále ukázkový („English abstract of the thesis.“). Napište vlastní abstrakt (`abstract.english`).",
    en: "The English abstract is still the template sample (\"English abstract of the thesis.\"). Write your own abstract (`abstract.english`).",
  ),
  "error_submit_check_keywords_cs_sample": (
    cs: "Česká klíčová slova jsou stále ukázková („klíčové slovo 1, …“). Vyplňte vlastní klíčová slova (`keywords.czech`).",
    en: "The Czech keywords are still the template sample (\"klíčové slovo 1, …\"). Fill in your own keywords (`keywords.czech`).",
  ),
  "error_submit_check_keywords_en_sample": (
    cs: "Anglická klíčová slova jsou stále ukázková („keyword 1, …“). Vyplňte vlastní klíčová slova (`keywords.english`).",
    en: "The English keywords are still the template sample (\"keyword 1, …\"). Fill in your own keywords (`keywords.english`).",
  ),
  "error_unsupported_faculty": (
    cs: "Nepodporovaná fakulta! Zvolte: `fvl` | `fvt` | `vlf` | `uo` | `uo-fvl` | `uo-fvt` | `uo-vlf`",
    en: "Unsupported faculty! Try: `fvl` | `fvt` | `vlf` | `uo` | `uo-fvl` | `uo-fvt` | `uo-vlf`",
  ),
  "error_unsupported_faculty_variant": (
    cs: "Nepodporovaná varianta fakulty! Zvolte: `1` | `2`",
    en: "Unsupported faculty variant! Try: `1` | `2`",
  ),
  "error_unsupported_city_variant": (
    cs: "Nepodporovaná varianta města! Zvolte: `1` | `2`",
    en: "Unsupported city variant! Try: `1` | `2`",
  ),
  "error_thesis_type_must_be_string": (
    cs: "Typ práce musí být řetězec.",
    en: "Thesis type must be a string.",
  ),
  "error_unsupported_thesis_type": (
    cs: "Nepodporovaný typ práce! Použijte `bachelor` | `master` | `doctoral`.",
    en: "Unsupported thesis type! Use `bachelor` | `master` | `doctoral`.",
  ),
  "error_unsupported_thesis_type_variant": (
    cs: "Nepodporovaný tvar názvu typu práce (`variant`). Použijte `1`, `2` nebo `3`.",
    en: "Unsupported thesis type name form (`variant`). Use `1`, `2`, or `3`.",
  ),
  "error_outlines_symbols_requires_dictionary": (
    cs: "Pro seznam symbolů (`outlines.symbols`) musí být `symbols` slovník.",
    en: "For symbol list (`outlines.symbols`), `symbols` must be a dictionary.",
  ),
  "error_vlna_bool": (
    cs: "Parametr `vlna` musí být `true`, `false` nebo `auto` (auto = vypnuto v draftu).",
    en: "`vlna` must be `true`, `false`, or `auto` (auto = disabled in draft).",
  ),
  "error_fancy_heading_bool": (
    cs: "Parametr `fancy_heading` musí být typu bool (`true` nebo `false`).",
    en: "`fancy_heading` must be a bool (`true` or `false`).",
  ),
  "error_submit_check_todo": (
    cs: "Při `submit_check: true` nesmí v dokumentu zůstat nevyřešené značky `#todo(...)`. Odstraňte je. Výskyty na:",
    en: "With `submit_check: true`, no unresolved `#todo(...)` markers may remain. Remove them. Found on:",
  ),
  "error_submit_check_keywords_cs_min": (
    cs: "Při `submit_check: true` musí česká klíčová slova (`keywords.czech`) obsahovat alespoň tři položky oddělené čárkou.",
    en: "With `submit_check: true`, Czech keywords (`keywords.czech`) must contain at least three comma-separated items.",
  ),
  "error_submit_check_keywords_en_min": (
    cs: "Při `submit_check: true` musí anglická klíčová slova (`keywords.english`) obsahovat alespoň tři položky oddělené čárkou.",
    en: "With `submit_check: true`, English keywords (`keywords.english`) must contain at least three comma-separated items.",
  ),
)

// Konstanty: Podporované výčtové hodnoty používané napříč moduly.
// Varianty `uo-*` = fakulta (název, barva, město) s logem Univerzity obrany.
#let supported_faculties = ("fvl", "fvt", "vlf", "uo", "uo-fvl", "uo-fvt", "uo-vlf")

// Funkce: base-faculty
// Účel: `uo-fvl` → `fvl` (varianty s logem UO sdílejí data základní fakulty).
#let base-faculty(faculty) = {
  let f = str(faculty)
  if f.starts-with("uo-") { f.slice(3) } else { f }
}
#let supported_thesis_types = ("bachelor", "master", "doctoral")

#let faculty_names = (
  "fvl": (
    cs: ([Fakulta vojenského leadershipu], [Fakulty vojenského leadershipu]),
    en: ([Faculty of Military Leadership], [Faculty of Military Leadership]),
  ),
  "fvt": (
    cs: ([Fakulta vojenských technologií], [Fakulty vojenských technologií]),
    en: ([Faculty of Military Technology], [Faculty of Military Technology]),
  ),
  "vlf": (
    cs: ([Vojenská lékařská fakulta], [Vojenské lékařské fakulty]),
    en: ([Military Faculty of Medicine], [Military Faculty of Medicine]),
  ),
  "uo": (
    cs: ([], []),
    en: ([], []),
  ),
)

#let city_names = (
  "fvl": ([BRNO], [Brně]),
  "fvt": ([BRNO], [Brně]),
  "uo": ([BRNO], [Brně]),
  "vlf": ([HRADEC KRÁLOVÉ], [Hradci Králové]),
)

#let thesis_type_forms = (
  "bachelor": (
    cs: ([Bakalářská práce], [bakalářské práce], [bakalářskou práci]),
    en: ([Bachelor Thesis], [bachelor thesis], [bachelor thesis]),
  ),
  "master": (
    cs: ([Diplomová práce], [diplomové práce], [diplomovou práci]),
    en: ([Master Thesis], [master thesis], [master thesis]),
  ),
  "doctoral": (
    cs: ([Disertační práce], [disertační práce], [disertační práci]),
    en: ([Dissertation], [dissertation], [dissertation]),
  ),
)
