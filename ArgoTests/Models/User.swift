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

  static func decode(json: JSON) -> User? {
    return _JSONParse(json) >>- { d in
      User.create
        <^> d <|  "id"
        <*> d <|  "name"
        <*> d <|* "email"
    }
  }
}
