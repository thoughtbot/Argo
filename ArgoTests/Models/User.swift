import Argo
import Curry

struct User {
  let id: Int
  let name: String
  let email: String?
}

extension User: Decodable {
  static func decode(j: JSON) -> Decoded<User> {
    return curry(self.init)
      <^> j <| "id"
      <*> j <| ["userinfo", "name"] <|> j <| "name"
      <*> j <|? "email"
  }
}
