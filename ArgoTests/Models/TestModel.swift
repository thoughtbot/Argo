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
}

extension TestModel: Decodable {
  static func decode(j: JSON) -> Decoded<TestModel> {
    return curry(self.init)
      <^> j <| "numerics"
      <*> j <| ["user_opt", "name"]
      <*> j <| "bool"
      <*> j <|| "string_array"
      <*> j <||? "string_array_opt"
      <*> j <|| ["embedded", "string_array"]
      <*> j <||? ["embedded", "string_array_opt"]
      <*> j <|? "user_opt"
  }
}

struct TestModelNumerics {
  let int: Int
  let int64: Int64
  let double: Double
  let float: Float
  let intOpt: Int?
}

extension TestModelNumerics: Decodable {
  static func decode(j: JSON) -> Decoded<TestModelNumerics> {
    return curry(self.init)
      <^> j <| "int"
      <*> j <| "int64"
      <*> j <| "double"
      <*> j <| "float"
      <*> j <|? "int_opt"
  }
}
