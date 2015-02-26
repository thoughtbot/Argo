public func decode<T: JSONDecodable where T == T.DecodedType>(object: AnyObject) -> T? {
  return decode(object).value
}

public func decode<T: JSONDecodable where T == T.DecodedType>(object: AnyObject) -> [T]? {
  return decode(object).value
}

public func decode<T: JSONDecodable where T == T.DecodedType>(object: AnyObject) -> Decoded<T> {
  return T.decode(JSON.parse(object))
}

public func decode<T: JSONDecodable where T == T.DecodedType>(object: AnyObject) -> Decoded<[T]> {
  return decodeArray(JSON.parse(object))
}
