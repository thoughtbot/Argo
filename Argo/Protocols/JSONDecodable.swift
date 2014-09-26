public protocol JSONDecodable {
  class func decode(json: JSON) -> Self?
}
