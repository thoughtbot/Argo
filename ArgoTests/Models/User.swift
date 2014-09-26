struct User {
  let id: Int
  let name: String
  let email: String?
}

import Argo

extension User: JSONDecodable {
  static func create(id: Int)(name: String)(email: String?) -> User {
    return User(id: id, name: name, email: email)
  }

  static var decoder: JSONValue -> User? {
     return User.create
      <^> <|"id"
      <*> <|"name"
      <*> <|*"email"
  }
}
