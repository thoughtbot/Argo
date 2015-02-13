import Argo
import Runes

struct Post {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
}

extension Post: JSONDecodable {
  static func create(id: Int)(text: String)(author: User)(comments: [Comment]) -> Post {
    return Post(id: id, text: text, author: author, comments: comments)
  }

  static func decode(j: JSONValue) -> Post? {
    return Post.create
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| "author"
      <*> j <|| "comments"
  }
}

extension Post: JSONEncodable {
  func encode() -> JSONValue {
    return ["id":id,"text":text,"author":author,"comments":JSONValue(array:comments)]
  }
}