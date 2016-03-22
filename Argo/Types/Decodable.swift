public protocol Decodable {
  associatedtype DecodedType = Self
  static func decode(json: JSON) -> Decoded<DecodedType>
}
