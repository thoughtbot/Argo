public protocol Decodable {
  typealias DecodedType = Self
  static func decode(json: JSON) -> Decoded<DecodedType>
}
