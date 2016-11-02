import XCTest
import Argo

class SwiftDictionaryDecodingTests: XCTestCase {
  func testDecodingAllTypesFromSwiftDictionary() {
    let typesDict: [String: Any] = [
       "numerics": [
        "int": 5,
        "int64": 900719,//9254740992, Dictionaries can't handle 64bit ints (iOS only, Mac works)
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

    XCTAssert(model != nil)
    XCTAssert(model?.numerics.int == 5)
    XCTAssert(model?.numerics.int64 == 900719)//9254740992)
    XCTAssert(model?.numerics.uint == 500)
    XCTAssert(model?.numerics.uint64 == 1039288)
    XCTAssert(model?.numerics.uint64String == 18446744073709551614)
    XCTAssert(model?.numerics.double == 3.4)
    XCTAssert(model?.numerics.float == 1.1)
    XCTAssert(model?.numerics.intOpt != nil)
    XCTAssert(model?.numerics.intOpt! == 4)
    XCTAssert(model?.string == "Cooler User")
    XCTAssert(model?.bool == false)
    XCTAssert(model?.stringArray.count == 2)
    XCTAssert(model?.stringArrayOpt == nil)
    XCTAssert(model?.eStringArray.count == 2)
    XCTAssert(model?.eStringArrayOpt != nil)
    XCTAssert(model?.eStringArrayOpt?.count == 0)
    XCTAssert(model?.userOpt != nil)
    XCTAssert(model?.userOpt?.id == 6)
    XCTAssert(model?.dict ?? [:] == ["foo": "bar"])
  }
}
