/**
  Convert an array of `Decoded<T>` values to a `Decoded` array of unwrapped `T`
  values

  This performs an all-or-nothing transformation on the array. If every element
  is `Success`, then this function will return `Success` along with the array of
  unwrapped `T` values.

  However, if _any_ of the elements are `Failure`, this function will also
  return `Failure`, and no array will be returned.

  - parameter xs: An array of `Decoded<T>` values

  - returns: A `Decoded` array of unwrapped `T` values
*/
public func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  return xs.reduce(pure([])) { accum, elem in
    curry(+) <^> accum <*> ({ [$0] } <^> elem)
  }
}

/**
  Convert a dictionary of `Decoded<T>` values and `String` keys to a `Decoded`
  dictionary of unwrapped `T` values and `String` keys

  This performs an all-or-nothing transformation on the dictionary. If every
  key is associated with a `Success`, then this function will return `Success`
  along with the dictionary of unwrapped `T` values associated with their
  original keys.

  However, if _any_ of the keys are associated with a `Failure`, this function
  will also return `Failure`, and no dictionary will be returned.

  - parameter xs: A dictionary of `Decoded<T>` values assigned to `String` keys

  - returns: A `Decoded` dictionary of unwrapped `T` values assigned to `String` keys
*/
public func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  return xs.reduce(pure([:])) { accum, elem in
    curry(+) <^> accum <*> ({ [elem.0: $0] } <^> elem.1)
  }
}
