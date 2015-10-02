/**
  return the left `Decoded` value if it is `.Success`, otherwise return the right side

  - If the left hand side is successful, this will return the left hand side
  - If the left hand side is unsuccesful, this will return the right hand side

  - parameter lhs: A value of type `Decoded<T>`
  - parameter rhs: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<T>`
*/

infix operator <|> { associativity left precedence 140 }

public func <|> <T>(lhs: Decoded<T>, rhs: Decoded<T>) -> Decoded<T> {
  if case .Success = lhs {
    return lhs
  }
  return rhs
}
