import Argo

struct Comment {
  let id: Int
  let text: String
  let authorName: String
}

extension Comment: Decodable {
  static func decode(j: JSON) throws -> Comment {
    return try Comment(id: j <| "id", text: j <| "text", authorName: j <| ["author", "name"])
  }
}
