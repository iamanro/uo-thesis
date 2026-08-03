#import "parse.typ": (
  glossary-to-acronyms,
  glossary-to-symbols,
  glossary-to-terms,
  normalize-glossary-input,
)
#import "registry.typ": has-used-acronyms, has-used-symbols, has-used-terms, init-glossary-runtime
#import "render.typ": generate-acronyms-list, generate-symbols-list, generate-terms-list
#import "runtime.typ": (
  first,
  first-plural,
  glossary-show,
  plural,
  singular,
  trm,
)
#import "validate.typ": validate-glossary-registry
