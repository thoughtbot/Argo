import Argo
import Runes

struct Comment {
  let id: Int
  let text: String
  let authorName: String
  let authorId: Int?
}

extension Comment: JSONDecodable {
  static func create(id: Int)(text: String)(authorName: String)(authorId: Int?) -> Comment {
    return Comment(id: id, text: text, authorName: authorName, authorId: authorId)
  }

  static func decode(j: JSONValue) -> Comment? {
    return Comment.create
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| ["author", "name"]
      <*> j <|? ["author", "id"]
  }
}
