public protocol JSONDecodable {
  class func decode(json: JSONValue) -> Self?
}
