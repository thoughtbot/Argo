import XCTest
import Argo

class EquatableTests: XCTestCase {
  func testEqualJSONObjects() {
    let json = JSONFromFile(file: "types").map(JSON.init)
    let anotherParsed = JSONFromFile(file: "types").map(JSON.init)

    XCTAssertEqual(json!, anotherParsed!)
  }

  func testNotEqualJSONObjects() {
    let json = JSONFromFile(file: "types").map(JSON.init)
    let anotherJSON = JSONFromFile(file: "types_fail_embedded").map(JSON.init)

    XCTAssertNotEqual(json!, anotherJSON!)
  }
}
