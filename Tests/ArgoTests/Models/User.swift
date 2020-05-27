import Argo
import Curry
import Runes

struct User {
  let id: Int
  let name: String
  let email: String?
}

extension User: Argo.Decodable {
  static func decode(_ json: JSON) -> Decoded<User> {
    return curry(self.init)
      <^> json["id"]
      <*> (json["userinfo", "name"] <|> json["name"])
      <*> .optional(json["email"])
  }
}
