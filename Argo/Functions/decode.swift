public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) throws -> T {
  return try T.decode(JSON.parse(object))
}

public func decode<T: Decodable where T == T.DecodedType>(object: AnyObject) throws -> [T] {
  return try decodeArray(JSON.parse(object))
}
