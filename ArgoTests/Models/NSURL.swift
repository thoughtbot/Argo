import Argo
import Foundation

extension NSURL: Decodable {
  public typealias DecodedType = NSURL

  public class func decode(j: JSON) throws -> NSURL {
    switch j {
    case .String(let urlString):
      if let url = NSURL(string: urlString) {
        return url
      } else {
        throw DecodedError.TypeMismatch("\(j) is not a URL")
      }
    default: throw DecodedError.TypeMismatch("\(j) is not a URL")
    }
  }
}
