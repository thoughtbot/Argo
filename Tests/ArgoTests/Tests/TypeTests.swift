import XCTest
import Argo

class TypeTests: XCTestCase {
  func testAllTheTypes() {
    let model: TestModel? = json(fromFile: "types").flatMap(decode)

    XCTAssert(model != nil)
    XCTAssert(model?.numerics.int == 5)
    XCTAssert(model?.numerics.int64 == 9007199254740992)
    XCTAssert(model?.numerics.int64String == 1076543210012345678)
    XCTAssert(model?.numerics.uint == 500)
    XCTAssert(model?.numerics.uint64 == 9223372036854775807)
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

  func testFailingEmbedded() {
    let model: TestModel? = json(fromFile: "types_fail_embedded").flatMap(decode)

    XCTAssert(model == nil)
  }

  func testBooleanDecoding() {
    let bools: Booleans? = json(fromFile: "booleans").flatMap(decode)

    XCTAssert(bools != nil)
    XCTAssert(bools?.bool == true)
    XCTAssert(bools?.number == true)
  }

  func testBooleanIdentification() {
    let j = json(fromFile: "booleans").map(JSON.init)!
    let boolean: JSON? = (j <| "realBool").value
    XCTAssert(boolean == .bool(true))
  }
}
