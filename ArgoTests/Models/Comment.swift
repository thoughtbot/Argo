import Argo
import Runes

struct Comment {
  let id: Int
  let text: String
  let authorName: String
}

extension Comment: Decodable {
  static func create(id: Int)(text: String)(authorName: String) -> Comment {
    return Comment(id: id, text: text, authorName: authorName)
  }

  static func decode(j: JSON) -> Decoded<Comment> {
    return Comment.create
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| ["author", "name"]
  }
}
