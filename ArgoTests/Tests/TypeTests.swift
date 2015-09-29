import XCTest
import Argo

class TypeTests: XCTestCase {
  func testAllTheTypes() {
    let model: TestModel? = JSONFromFile("types").flatMap(decode)

    XCTAssert(model != nil)
    XCTAssert(model?.numerics.int == 5)
    XCTAssert(model?.numerics.int64 == 9007199254740992)
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
    let model: TestModel? = JSONFromFile("types_fail_embedded").flatMap(decode)

    XCTAssert(model == nil)
  }
}
