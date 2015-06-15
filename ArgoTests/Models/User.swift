import Argo

struct User {
  let id: Int
  let name: String
  let email: String?
}

extension User: Decodable {
  static func decode(j: JSON) throws -> User {
    return try User(id: j <| "id", name: j <| "name", email: j <|? "email")
  }
}
