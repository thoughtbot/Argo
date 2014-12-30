import XCTest
import Argo

class ExampleTests: XCTestCase {
  func testJSONWithRootArray() {
    let json: AnyObject? = JSONFileReader.JSON(fromFile: "array_root")
    let stringArray: [String]? = json >>- JSONValue.parse >>- JSONValue.map

    XCTAssertNotNil(stringArray)
    XCTAssertEqual(stringArray!, ["foo", "bar", "baz"])
  }

  func testJSONWithRootObject() {
    let json: AnyObject? = JSONFileReader.JSON(fromFile: "root_object")
    let user: User? = json >>- JSONValue.parse >>- { $0["user"] >>- User.decode }

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email != nil)
    XCTAssert(user?.email! == "u.cool@example.com")
  }
}
