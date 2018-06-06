import Argo
import Curry
import Runes

struct User {
  let id: Int
  let name: String
  let email: String?
}

extension User: Argo.Decodable {
  static func decode(_ value: Value) -> Decoded<User> {
    return curry(self.init)
      <^> value["id"]
      <*> (value["userinfo", "name"] <|> value["name"])
      <*> value[optional: "email"]
  }
}
