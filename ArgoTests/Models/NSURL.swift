import Argo
import Foundation

extension NSURL: Decodable {
  public typealias DecodedType = NSURL

  public class func decode(j: JSON) -> Decoded<NSURL> {
    switch j {
    case .String(let urlString):
      return NSURL(string: urlString).map(pure) ?? .Failure(.TypeMismatch("\(j) is not a URL"))
    default: return .Failure(.TypeMismatch("\(j) is not a URL"))
    }
  }
}
