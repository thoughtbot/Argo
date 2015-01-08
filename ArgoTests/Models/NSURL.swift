import Argo
import Foundation

extension NSURL: JSONDecodable {
  public typealias DecodedType = NSURL

  public class func decode(j: JSONValue) -> DecodedType? {
        switch j {
        case .JSONString(let url): return NSURL(string: url)
        default: return .None
        }
    }
}
