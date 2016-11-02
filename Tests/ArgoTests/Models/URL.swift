import Argo
import Foundation

extension URL: Decodable {
  public static func decode(_ json: JSON) -> Decoded<URL> {
    switch json {
    case .string(let urlString):
      return URL(string: urlString).map(pure) ?? .typeMismatch(expected: "URL", actual: json)
    default: return .typeMismatch(expected: "URL", actual: json)
    }
  }
}
