struct User {
  let id: Int
  let name: String
  let email: String?
}

import Argo

extension User: JSONDecodable {
  static func create(id: Int)(name: String)(email: String?) -> User {
    println("create user")
    return User(id: id, name: name, email: email)
  }

  static func decode(json: JSONValue) -> User? {
    return User.create
      <^> json <|  "id"
      <*> json <|  "name"
      <*> json <|* "email"
  }
}
