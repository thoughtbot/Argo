import Argo
import Foundation

extension NSURL: Decodable {
  public typealias DecodedType = NSURL

  public class func decode(_ json: JSON) -> Decoded<NSURL> {
    switch json {
    case .String(let urlString):
      return NSURL(string: urlString).map(pure) ?? .typeMismatch(expected: "URL", actual: json)
    default: return .typeMismatch(expected: "URL", actual: json)
    }
  }
}
