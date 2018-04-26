import XCTest
import Argo

class SwiftDictionaryDecodingTests: XCTestCase {
  func testDecodingAllTypesFromSwiftDictionary() {
    let typesDict: [String: Any] = [
       "numerics": [
        "int": 5,
        "int64": 900719,
        "int64_string": "1076543210012345678",
        "double": 3.4,
        "float": 1.1,
        "int_opt": 4,
        "uint": 500,
        "uint64": 1039288,
        "uint64_string": "18446744073709551614"
      ],
      "bool": false,
      "string_array": ["hello", "world"],
      "embedded": [
        "string_array": ["hello", "world"],
        "string_array_opt": []
      ],
      "user_opt": [
        "id": 6,
        "name": "Cooler User"
      ],
      "dict": [
        "foo": "bar"
      ]
    ]

    let model: TestModel? = decode(typesDict)

    XCTAssertEqual(model?.numerics.int, 5)
    XCTAssertEqual(model?.numerics.int64, 900719)
    XCTAssertEqual(model?.numerics.uint, 500)
    XCTAssertEqual(model?.numerics.uint64, 1039288)
    XCTAssertEqual(model?.numerics.uint64String, 18446744073709551614)
    XCTAssertEqual(model?.numerics.double, 3.4)
    XCTAssertEqual(model?.numerics.float, 1.1)
    XCTAssertEqual(model?.numerics.intOpt!, 4)
    XCTAssertEqual(model?.string, "Cooler User")
    XCTAssertEqual(model?.bool, false)
    XCTAssertEqual(model?.stringArray.count, 2)
    XCTAssertNil(model?.stringArrayOpt)
    XCTAssertEqual(model?.eStringArray.count, 2)
    XCTAssertEqual(model?.eStringArrayOpt?.count, 0)
    XCTAssertEqual(model?.userOpt?.id, 6)
    XCTAssertEqual(model?.dict, ["foo": "bar"])
  }
}
