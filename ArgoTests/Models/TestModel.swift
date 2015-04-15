import Argo
import Runes

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
  static func create(numerics: TestModelNumerics)(string: String)(bool: Bool)(stringArray: [String])(stringArrayOpt: [String]?)(eStringArray: [String])(eStringArrayOpt: [String]?)(userOpt: User?) -> TestModel {
    return TestModel(numerics: numerics, string: string, bool: bool, stringArray: stringArray, stringArrayOpt: stringArrayOpt, eStringArray: eStringArray, eStringArrayOpt: eStringArrayOpt, userOpt: userOpt)
  }

  static func decode(j: JSON) -> Decoded<TestModel> {
    return TestModel.create
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
  static func create(int: Int)(int64: Int64)(double: Double)(float: Float)(intOpt: Int?) -> TestModelNumerics {
    return TestModelNumerics(int: int, int64: int64, double: double, float: float, intOpt: intOpt)
  }

  static func decode(j: JSON) -> Decoded<TestModelNumerics> {
    return TestModelNumerics.create
      <^> j <| "int"
      <*> j <| "int64"
      <*> j <| "double"
      <*> j <| "float"
      <*> j <|? "int_opt"
  }
}
