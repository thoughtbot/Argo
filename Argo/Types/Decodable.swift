public protocol Decodable {
  typealias DecodedType = Self
  static func decode(json: JSON) throws -> DecodedType
}
