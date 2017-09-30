import XCTest
import Argo
import Curry
import Runes

class ExampleTests: XCTestCase {
  func testJSONWithRootArray() {
    let stringArray: [String]? = json(fromFile: "array_root").flatMap(decode)

    XCTAssertEqual(stringArray, ["foo", "bar", "baz"])
  }

  func testJSONWithRootObject() {
    let object = json(fromFile: "root_object") as? [String: Any]
    let user: User? = object.flatMap { decode($0, rootKey: "user") }

    XCTAssertEqual(user?.id, 1)
    XCTAssertEqual(user?.name, "Cool User")
    XCTAssertEqual(user?.email!, "u.cool@example.com")
  }

  func testDecodingNonFinalClass() {
    let object = json(fromFile: "url") as? [String: Any]
    let url: URL? = object.flatMap { decode($0, rootKey: "url") }

    XCTAssertEqual(url?.absoluteString, "http://example.com")
  }

  func testDecodingJSONWithRootArray() {
    let expected = Value([["title": "Foo", "age": 21], ["title": "Bar", "age": 32]])
    let j = json(fromFile: "root_array").map(Value.init)

    XCTAssertEqual(expected, j)
  }

  func testFlatMapOptionals() {
    let j: Any? = json(fromFile: "user_with_email")
    let user: User? = j.flatMap(decode)

    XCTAssertEqual(user?.id, 1)
    XCTAssertEqual(user?.name, "Cool User")
    XCTAssertEqual(user?.email, "u.cool@example.com")
  }
  
  func testNilCoalescing() {
    let j: Any? = json(fromFile: "user_with_nested_name")
    let user: User? = j.flatMap(decode)

    XCTAssertEqual(user?.id, 1)
    XCTAssertEqual(user?.name, "Very Cool User")
    XCTAssertEqual(user?.email, "u.cool@example.com")
  }

  func testFlatMapDecoded() {
    let j: Any? = json(fromFile: "user_with_email")
    let user: Decoded<User> = .fromOptional(j) >>- decode

    XCTAssertEqual(user.value?.id, 1)
    XCTAssertEqual(user.value?.name, "Cool User")
    XCTAssertEqual(user.value?.email, "u.cool@example.com")
  }
}
