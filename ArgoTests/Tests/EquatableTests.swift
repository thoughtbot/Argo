import XCTest
import Argo

class EquatableTests: XCTestCase {
  func testEqualJSONObjects() {
    let j = json(fromFile: "types").map(JSON.init)
    let anotherParsed = json(fromFile: "types").map(JSON.init)

    XCTAssertEqual(j!, anotherParsed!)
  }

  func testNotEqualJSONObjects() {
    let j = json(fromFile: "types").map(JSON.init)
    let anotherJSON = json(fromFile: "types_fail_embedded").map(JSON.init)

    XCTAssertNotEqual(j!, anotherJSON!)
  }
}
