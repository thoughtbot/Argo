import Argo

struct Post {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
}

extension Post: Decodable {
  static func decode(j: JSON) throws -> Post {
    return try Post(id: j <| "id", text: j <| "text", author: j <| "author", comments: j <|| "comments")
  }
}
