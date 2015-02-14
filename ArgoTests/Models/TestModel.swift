import Argo
import Runes

struct TestModel {
  let int: Int
  let string: String
  let double: Double
  let float: Float
  let bool: Bool
  let intOpt: Int?
  let stringArray: [String]
  let stringArrayOpt: [String]?
  let eStringArray: [String]
  let eStringArrayOpt: [String]?
  let userOpt: User?
}

extension TestModel: JSONDecodable {
  static func create(int: Int)(string: String)(double: Double)(float: Float)(bool: Bool)(intOpt: Int?)(stringArray: [String])(stringArrayOpt: [String]?)(eStringArray: [String])(eStringArrayOpt: [String]?)(userOpt: User?) -> TestModel {
    return TestModel(int: int, string: string, double: double, float: float, bool: bool, intOpt: intOpt, stringArray: stringArray, stringArrayOpt: stringArrayOpt, eStringArray: eStringArray, eStringArrayOpt: eStringArrayOpt, userOpt: userOpt)
  }

  static func decode(j: JSONValue) -> TestModel? {
    return TestModel.create
      <^> j <| "int"
      <*> j <| ["user_opt", "name"]
      <*> j <| "double"
      <*> j <| "float"
      <*> j <| "bool"
      <*> j <|? "int_opt"
      <*> j <|| "string_array"
      <*> j <||? "string_array_opt"
      <*> j <|| ["embedded", "string_array"]
      <*> j <||? ["embedded", "string_array_opt"]
      <*> j <|? "user_opt"
  }
}
