import XCTest
import Argo
import Curry
import Runes

class ExampleTests: XCTestCase {
  func testJSONWithRootArray() {
    let stringArray: [String]? = json(fromFile: "array_root").flatMap(decode)

    XCTAssertNotNil(stringArray)
    XCTAssertEqual(stringArray!, ["foo", "bar", "baz"])
  }

  func testJSONWithRootObject() {
    let object = json(fromFile: "root_object") as? [String: Any]
    let user: User? = object.flatMap { decode($0, rootKey: "user") }

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email != nil)
    XCTAssert(user?.email! == "u.cool@example.com")
  }

  func testDecodingNonFinalClass() {
    let object = json(fromFile: "url") as? [String: Any]
    let url: URL? = object.flatMap { decode($0, rootKey: "url") }

    XCTAssert(url != nil)
    XCTAssert(url?.absoluteString == "http://example.com")
  }

  func testDecodingJSONWithRootArray() {
    let expected = JSON([["title": "Foo", "age": 21], ["title": "Bar", "age": 32]])
    let j = json(fromFile: "root_array").map(JSON.init)

    XCTAssert(.some(expected) == j)
  }

  func testFlatMapOptionals() {
    let j: Any? = json(fromFile: "user_with_email")
    let user: User? = j.flatMap(decode)

    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email == "u.cool@example.com")
  }
  
  func testNilCoalescing() {
    let j: Any? = json(fromFile: "user_with_nested_name")
    let user: User? = j.flatMap(decode)

    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Very Cool User")
    XCTAssert(user?.email == "u.cool@example.com")
  }

  func testFlatMapDecoded() {
    let j: Any? = json(fromFile: "user_with_email")
    let user: Decoded<User> = .fromOptional(j) >>- decode

    XCTAssert(user.value?.id == 1)
    XCTAssert(user.value?.name == "Cool User")
    XCTAssert(user.value?.email == "u.cool@example.com")
  }
}
