public protocol JSONDecodable {
  class func decode(JSONValue) -> Self?
}
