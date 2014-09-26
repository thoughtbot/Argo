struct Comment {
  let id: Int
  let text: String
  let authorName: String
}

import Argo

extension Comment: JSONDecodable {
  static func create(id: Int)(text: String)(authorName: String) -> Comment {
    return Comment(id: id, text: text, authorName: authorName)
  }

  static func decode(json: JSONValue) -> Comment? {
    return Comment.create
      <^> json <| "id"
      <*> json <| "text"
      <*> json <| "author" <| "name"
  }
}
