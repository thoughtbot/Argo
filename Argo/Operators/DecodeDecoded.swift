/**
  Attempt to decode a value at the specified key into the requested type

  This operator is used to decode a mandatory value from the JSON. If the
  decoding fails for any reason, this will result in a `Failure` being
  returned.

  - parameter json: The `JSON` object containing the key
  - parameter key: The key for the object to decode

  - returns: A `Decoded` value representing the success or failure of the
             decode operation
*/
public func <| <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> Decoded<T> {
  return json <| [key]
}

/**
  Attempt to decode an optional value at the specified key into the requested
  type

  This operator is used to decode an optional value from the JSON. If the key
  isn't present in the JSON, this will still return `Success`. However, if the
  key exists but the object assigned to that key is unable to be decoded into the
  requested type, this will return `Failure`.

  - parameter json: The `JSON` object containing the key
  - parameter key: The key for the object to decode

  - returns: A `Decoded` optional value representing the success or failure of the
             decode operation
*/
public func <|? <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> Decoded<T?> {
  return .optional(json <| [key])
}

/**
  Attempt to decode a value at the specified key path into the requested type

  This operator is used to decode a mandatory value from the JSON. If the
  decoding fails for any reason, this will result in a `Failure` being
  returned.

  - parameter json: The `JSON` object containing the key
  - parameter keys: The key path for the object to decode, represented by an
                    array of strings

  - returns: A `Decoded` value representing the success or failure of the
             decode operation
*/
public func <| <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> Decoded<T> {
  return flatReduce(keys, initial: json, combine: decodedJSON) >>- T.decode
}

/**
  Attempt to decode an optional value at the specified key path into the
  requested type

  This operator is used to decode an optional value from the JSON. If any of
  the keys in the key path aren't present in the JSON, this will still return
  `Success`. However, if the key path exists but the object assigned to the final
  key is unable to be decoded into the requested type, this will return
  `Failure`.

  - parameter json: The `JSON` object containing the key
  - parameter keys: The key path for the object to decode, represented by an
                    array of strings

  - returns: A `Decoded` optional value representing the success or failure of the
             decode operation
*/
public func <|? <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> Decoded<T?> {
  return .optional(json <| keys)
}


/**
  Attempt to decode an array of values at the specified key into the requested
  type

  This operator is used to decode a mandatory array of values from the JSON. If
  the decoding of any of the objects fail for any reason, this will result in a
  `Failure` being returned.

  - parameter json: The `JSON` object containing the key
  - parameter key: The key for the array of objects to decode

  - returns: A `Decoded` array of values representing the success or failure of
             the decode operation
*/
public func <|| <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> Decoded<[T]> {
  return json <|| [key]
}

/**
  Attempt to decode an optional array of values at the specified key into the
  requested type

  This operator is used to decode an optional array of values from the JSON. If
  the key isn't present in the JSON, this will still return `Success`. However,
  if the key exists but the objects assigned to that key are unable to be decoded
  into the requested type, this will return `Failure`.

  - parameter json: The `JSON` object containing the key
  - parameter key: The key for the object to decode

  - returns: A `Decoded` optional array of values representing the success or
             failure of the decode operation
*/
public func <||? <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> Decoded<[T]?> {
  return .optional(json <|| [key])
}

/**
  Attempt to decode an array of values at the specified key path into the
  requested type

  This operator is used to decode a mandatory array of value from the JSON. If
  the decoding fails for any reason, this will result in a `Failure` being
  returned.

  - parameter json: The `JSON` object containing the key
  - parameter keys: The key path for the object to decode, represented by an
                    array of strings

  - returns: A `Decoded` array of values representing the success or failure of
             the decode operation
*/
public func <|| <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> Decoded<[T]> {
  return flatReduce(keys, initial: json, combine: decodedJSON) >>- Array<T>.decode
}

/**
  Attempt to decode an optional array of values at the specified key path into
  the requested type

  This operator is used to decode an optional array of values from the JSON. If
  any of the keys in the key path aren't present in the JSON, this will still
  return `Success`. However, if the key path exists but the objects assigned to
  the final key are unable to be decoded into the requested type, this will
  return `Failure`.

  - parameter json: The `JSON` object containing the key
  - parameter keys: The key path for the object to decode, represented by an
                    array of strings

  - returns: A `Decoded` optional array of values representing the success or
             failure of the decode operation
*/
public func <||? <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> Decoded<[T]?> {
  return .optional(json <|| keys)
}
