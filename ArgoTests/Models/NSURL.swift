import Argo
import Foundation

extension NSURL: JSONDecodable {
  public typealias DecodedType = NSURL

  public class func decode(j: JSON) -> DecodedType? {
        switch j {
        case .String(let url): return NSURL(string: url)
        default: return .None
        }
    }
}
