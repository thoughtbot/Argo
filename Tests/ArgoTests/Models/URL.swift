import Argo
import Foundation

extension URL: Argo.Decodable {
  public static func decode(_ value: Value) -> Decoded<URL> {
    switch value {
    case .string(let urlString):
      return URL(string: urlString).map(pure) ?? .typeMismatch(expected: "URL", actual: value)
    default: return .typeMismatch(expected: "URL", actual: value)
    }
  }
}
