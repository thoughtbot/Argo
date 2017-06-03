#if SWIFT_PACKAGE
@_exported import Runes
#else
import Runes
#endif

infix operator <^> : RunesApplicativePrecedence
infix operator <*> : RunesApplicativePrecedence
infix operator <* : RunesApplicativeSequencePrecedence
infix operator *> : RunesApplicativeSequencePrecedence
infix operator <|> : RunesAlternativePrecedence
infix operator >>- : RunesMonadicPrecedenceLeft
infix operator -<< : RunesMonadicPrecedenceRight
infix operator >-> : RunesMonadicPrecedenceRight
infix operator <-< : RunesMonadicPrecedenceRight
