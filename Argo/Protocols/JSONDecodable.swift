public protocol JSONDecodable {
  class var decoder: JSONValue -> Self? { get }
}
