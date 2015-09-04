import Argo
import Foundation

extension NSURL: Decodable {
  public typealias DecodedType = NSURL

  public class func decode(j: JSON) -> Decoded<NSURL> {
    switch j {
    case .String(let urlString):
      return NSURL(string: urlString).map(pure) ?? .typeMismatch("URL", actual: j)
    default: return .typeMismatch("URL", actual: j)
    }
  }
}
