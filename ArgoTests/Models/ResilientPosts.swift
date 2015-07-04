import Argo
import Runes

struct ResilientPost {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
}

extension ResilientPost : Decodable {
  static func create(id: Int)(text: String)(author: User)(comments: [Comment]) -> ResilientPost {
    return ResilientPost(id: id, text: text, author: author, comments: comments)
  }

  static func decode(j: JSON) -> Decoded<ResilientPost> {
    return ResilientPost.create
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| "author"
      <*> j <|?| "comments"
  }
}