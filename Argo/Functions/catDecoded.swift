/**
  Remove `Failure` values from an array and unwrap `Success`es

  This will iterate through the array of `Decoded` values and ensure that each
  is `Success`. If it is, it will unwrap the contained `T` value. If it is
  `Failure`, it will be removed from the array.

  - parameter xs: An array of `Decoded` values

  - returns: An array of unwrapped values of type `T`
*/
public func catDecoded<T>(xs: [Decoded<T>]) -> [T] {
  return xs.reduce([]) { accum, elem in
    elem.map { accum + [$0] } ?? accum
  }
}

/**
  Remove `Failure` values from a dictionary and unwrap `Success`es

  This will iterate through the dictionary of `Decoded` values and ensure that
  each is `Success`. If it is, it will unwrap the contained `T` value and assign
  it back to the original key. If it is `Failure`, it will be removed from the
  dictionary, along with the original key.

  - parameter xs: A dictionary of `Decoded` values assigned to `String` keys

  - returns: A dictionary of unwrapped values of type `T` assigned to `String` keys
*/
public func catDecoded<T>(xs: [String: Decoded<T>]) -> [String: T] {
  return xs.reduce([:]) { accum, elem in
    elem.1.map { accum + [elem.0: $0] } ?? accum
  }
}
