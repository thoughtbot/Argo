import Argo
import Runes

struct User {
  let id: Int
  let name: String
  let email: String?
}

extension User: Decodable {
  static func decode(j: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> j <| "id"
      <*> j <| "name"
      <*> j <| "email"
  }
}
