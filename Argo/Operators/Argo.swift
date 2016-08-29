import Runes

precedencegroup DecodePrecedence {
  associativity: left
  higherThan: ApplicativeSequencePrecedence
  lowerThan: NilCoalescingPrecedence
}

infix operator <| : DecodePrecedence
infix operator <|? : DecodePrecedence
infix operator <|| : DecodePrecedence
infix operator <||? : DecodePrecedence
