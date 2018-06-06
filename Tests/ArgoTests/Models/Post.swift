import Argo
import Curry
import Runes

struct Post {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
}

extension Post: Argo.Decodable {
  static func decode(_ value: Value) -> Decoded<Post> {
    return curry(self.init)
      <^> value["id"]
      <*> value["text"]
      <*> value["author"]
      <*> value["comments"]
  }
}

struct LocationPost {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
  let location: Location?
}

extension LocationPost: Argo.Decodable {
  static func decode(_ value: Value) -> Decoded<LocationPost> {
    return curry(self.init)
      <^> value["id"]
      <*> value["text"]
      <*> value["author"]
      <*> value["comments"]
      <*> value[optional: "location"]
  }
}

struct Location {
  let lat: Double
  let lng: Double
  let title: String
}

extension Location: Argo.Decodable {
  static func decode(_ value: Value) -> Decoded<Location> {
    return curry(self.init)
      <^> value["lat"]
      <*> value["lng"]
      <*> value["title"]
  }
}
