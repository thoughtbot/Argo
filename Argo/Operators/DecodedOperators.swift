// MARK: Monadic Operators for the Decoded type

/**
  flatMap a function over a `Decoded` value (right associative)

  - If the value is a failing case (`.TypeMismatch`, `.MissingKey`), the function will not be evaluated and this will return the value
  - If the value is `.Success`, the function will be applied to the unwrapped value

  - parameter a: A value of type `Decoded<A>`
  - parameter f: A transformation function from type `A` to type `Decoded<B>`

  - returns: A value of type `Decoded<B>`
*/
public func >>- <A, B>(a: Decoded<A>, f: A -> Decoded<B>) -> Decoded<B> {
  return a.flatMap(f)
}

/**
  map a function over a `Decoded` value

  - If the value is is a failing case (`.TypeMismatch`, `.MissingKey`), the function will not be evaluated and this will return the value
  - If the value is `.Success`, the function will be applied to the unwrapped value

  - parameter f: A transformation function from type `A` to type `B`
  - parameter a: A value of type `Decoded<A>`

  - returns: A value of type `Decoded<B>`
*/
public func <^> <A, B>(f: A -> B, a: Decoded<A>) -> Decoded<B> {
  return a.map(f)
}

/**
  apply a `Decoded` function to a `Decoded` value

  - If the function is a failing case (`.TypeMismatch`, `.MissingKey`), this will return the function's value
  - If the function is a `.Success` case and the value is a failure case, this will return the value
  - If both self and the function are `.Success`, the function will be applied to the unwrapped value

  - parameter f: A `Decoded` transformation function from type `A` to type `B`
  - parameter a: A value of type `Decoded<A>`

  - returns: A value of type `Decoded<B>`
*/
public func <*> <A, B>(f: Decoded<A -> B>, a: Decoded<A>) -> Decoded<B> {
  return a.apply(f)
}

// MARK: Alternative operator

/**
  return the left `Decoded` value if it is `.Success`, otherwise return the right side

  - If the left hand side is successful, this will return the left hand side
  - If the left hand side is unsuccesful, this will return the right hand side

  - parameter lhs: A value of type `Decoded<A>`
  - parameter rhs: A value of type `Decoded<A>`

  - returns: A value of type `Decoded<A>`
*/

infix operator <|> { associativity left precedence 140 }

public func <|><A>(lhs: Decoded<A>, rhs: Decoded<A>) -> Decoded<A> {
  if case .Success = lhs {
    return lhs
  }
  return rhs
}
