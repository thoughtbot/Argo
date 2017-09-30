import XCTest
import Argo

class EquatableTests: XCTestCase {
  func testEqualJSONObjects() {
    let j = json(fromFile: "types").map(Value.init)
    let anotherParsed = json(fromFile: "types").map(Value.init)

    XCTAssertEqual(j, anotherParsed)
  }

  func testNotEqualJSONObjects() {
    let j = json(fromFile: "types").map(Value.init)
    let anotherJSON = json(fromFile: "types_fail_embedded").map(Value.init)

    XCTAssertNotEqual(j, anotherJSON)
  }
}
