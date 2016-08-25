import Runes

precedencegroup DecodePrecedence {
  associativity: left
  higherThan: ApplicativeSequencePrecedence
}

infix operator <| : DecodePrecedence
infix operator <|? : DecodePrecedence
infix operator <|| : DecodePrecedence
infix operator <||? : DecodePrecedence
