import XCTest
import Argo

class PListDecodingTests: XCTestCase {
  func testDecodingAllTypesFromPList() {
    let model: TestModel? = PListFileReader.plist(fromFile: "types").flatMap(decode)

    XCTAssert(model != nil)
    XCTAssert(model?.numerics.int == 5)
    XCTAssert(model?.numerics.int64 == 9007199254740992)
    XCTAssert(model?.numerics.uint == 500)
    XCTAssert(model?.numerics.uint64 == 9223372036854775807)
    XCTAssert(model?.numerics.uint64String == 18446744073709551614)
    XCTAssert(model?.numerics.double == 3.4)
    XCTAssert(model?.numerics.float == 1.1)
    XCTAssert(model?.numerics.intOpt == nil)
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
