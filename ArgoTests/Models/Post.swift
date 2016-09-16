import Argo
import Curry
import Runes

struct Post {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
}

extension Post: Decodable {
  static func decode(_ json: JSON) -> Decoded<Post> {
    return curry(self.init)
      <^> json <| "id"
      <*> json <| "text"
      <*> json <| "author"
      <*> json <|| "comments"
  }
}

struct LocationPost {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
  let location: Location?
}

extension LocationPost: Decodable {
  static func decode(_ json: JSON) -> Decoded<LocationPost> {
    return curry(self.init)
      <^> json <| "id"
      <*> json <| "text"
      <*> json <| "author"
      <*> json <|| "comments"
      <*> json <|? "location"
  }
}

struct Location {
  let lat: Double
  let lng: Double
  let title: String
}

extension Location: Decodable {
  static func decode(_ json: JSON) -> Decoded<Location> {
    return curry(self.init)
      <^> json <| "lat"
      <*> json <| "lng"
      <*> json <| "title"
  }
}
