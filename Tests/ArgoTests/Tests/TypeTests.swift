import XCTest
import Argo

class TypeTests: XCTestCase {
  func testAllTheTypes() {
    let model: TestModel? = json(fromFile: "types").flatMap(decode)

    XCTAssertEqual(model?.numerics.int, 5)
    XCTAssertEqual(model?.numerics.int64, 9007199254740992)
    XCTAssertEqual(model?.numerics.int64String, 1076543210012345678)
    XCTAssertEqual(model?.numerics.uint, 500)
    XCTAssertEqual(model?.numerics.uint64, 9223372036854775807)
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

  func testFailingEmbedded() {
    let model: TestModel? = json(fromFile: "types_fail_embedded").flatMap(decode)

    XCTAssertNil(model)
  }

  func testBooleanDecoding() {
    let bools: Booleans? = json(fromFile: "booleans").flatMap(decode)

    XCTAssertEqual(bools?.bool, true)
    XCTAssertEqual(bools?.number, true)
  }

  func testBooleanIdentification() {
    let v = json(fromFile: "booleans").map(Value.init)!
    let boolean: Value? = v["realBool"].value

    XCTAssertEqual(boolean, .bool(true))
  }
}
