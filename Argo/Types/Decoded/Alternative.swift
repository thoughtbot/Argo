/**
  return the left `Decoded` value if it is `.Success`, otherwise return the right side

  - If the left hand side is successful, this will return the left hand side
  - If the left hand side is unsuccesful, this will return the right hand side

  - parameter lhs: A value of type `Decoded<T>`
  - parameter rhs: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<T>`
*/

infix operator <|> { associativity left precedence 140 }

public func <|> <T>(lhs: Decoded<T>, @autoclosure rhs: () -> Decoded<T>) -> Decoded<T> {
  return lhs.or(rhs)
}

public extension Decoded {
  func or(@autoclosure other: () -> Decoded<T>) -> Decoded<T> {
    switch self {
      case .Success: return self
      case .Failure: return other()
    }
  }
}
