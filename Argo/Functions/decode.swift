// MARK: decode root objects and arrays

public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> T? {
  return decode(object).value
}

public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> [T]? {
  return decode(object).value
}

public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> Decoded<T> {
  return T.decode(JSON.parse(object))
}

public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) -> Decoded<[T]> {
  return Array<T>.decode(JSON.parse(object))
}

// MARK: decode with a root key

public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> T? {
  return decodeWithRootKey(rootKey, object).value
}

public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> [T]? {
  return decodeWithRootKey(rootKey, object).value
}

public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> Decoded<T> {
  return JSON.parse(object) <| rootKey
}

public func decodeWithRootKey<T: Decodable where T == T.DecodedType>(rootKey: String, _ object: AnyObject) -> Decoded<[T]> {
  return JSON.parse(object) <|| rootKey
}
