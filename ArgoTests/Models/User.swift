import Argo
import Runes

struct User {
  let id: Int
  let name: String
  let email: String?
}

extension User: JSONDecodable {
  static func create(id: Int)(name: String)(email: String?) -> User {
    return User(id: id, name: name, email: email)
  }

  static func decode(j: JSONValue) -> User? {
    return User.create
      <^> j <| "id"
      <*> j <| "name"
      <*> j <|? "email"
  }
}
