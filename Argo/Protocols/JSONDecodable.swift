public protocol JSONDecodable {
  typealias DecodedType = Self
  static func decode(JSONValue) -> DecodedType?
}
