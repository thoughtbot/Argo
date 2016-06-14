import Argo
import Curry

struct TestModel {
  let numerics: TestModelNumerics
  let string: String
  let bool: Bool
  let stringArray: [String]
  let stringArrayOpt: [String]?
  let eStringArray: [String]
  let eStringArrayOpt: [String]?
  let userOpt: User?
  let dict: [String: String]
}

extension TestModel: Decodable {
  static func decode(_ json: JSON) -> Decoded<TestModel> {
    let curriedInit = curry(self.init)
    return curriedInit
      <^> json <| "numerics"
      <*> json <| ["user_opt", "name"]
      <*> json <| "bool"
      <*> json <|| "string_array"
      <*> json <||? "string_array_opt"
      <*> json <|| ["embedded", "string_array"]
      <*> json <||? ["embedded", "string_array_opt"]
      <*> json <|? "user_opt"
      <*> (json <| "dict" >>- { [String: String].decode($0) })
  }
}

struct TestModelNumerics {
  let int: Int
  let int64: Int64
  let int64String: Int64
  let double: Double
  let float: Float
  let intOpt: Int?
}

extension TestModelNumerics: Decodable {
  static func decode(_ json: JSON) -> Decoded<TestModelNumerics> {
    return curry(self.init)
      <^> json <| "int"
      <*> json <| "int64"
      <*> json <| "int64_string"
      <*> json <| "double"
      <*> json <| "float"
      <*> json <|? "int_opt"
  }
}
