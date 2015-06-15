import Argo

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
  static func decode(j: JSON) throws -> TestModel {
    return try TestModel(
      numerics: j <| "numerics",
      string: j <| ["user_opt", "name"],
      bool: j <| "bool",
      stringArray: j <|| "string_array",
      stringArrayOpt: j <||? "string_array_opt",
      eStringArray: j <|| ["embedded", "string_array"],
      eStringArrayOpt: j <||? ["embedded", "string_array_opt"],
      userOpt: j <|? "user_opt")
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
  static func decode(j: JSON) throws -> TestModelNumerics {
    return try TestModelNumerics(
      int: j <| "int",
      int64: j <| "int64",
      double: j <| "double",
      float: j <| "float",
      intOpt: j <|? "int_opt")
  }
}
