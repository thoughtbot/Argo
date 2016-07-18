import Argo
import Foundation

extension URL: Decodable {
  public typealias DecodedType = URL

  public static func decode(_ json: JSON) -> Decoded<URL> {
    switch json {
    case .string(let urlString):
      return URL(string: urlString).map(pure) ?? .typeMismatch("URL", actual: json)
    default: return .typeMismatch("URL", actual: json)
    }
  }
}
