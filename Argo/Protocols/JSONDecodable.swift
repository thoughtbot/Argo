public protocol JSONDecodable {
  typealias DecodedType = Self
  class func decode(JSONValue) -> DecodedType?
}
