import XCTest
import Argo
import Curry

class ExampleTests: XCTestCase {
  func testJSONWithRootArray() {
    let stringArray: [String]? = JSONFromFile(file: "array_root").flatMap(decode)

    XCTAssertNotNil(stringArray)
    XCTAssertEqual(stringArray!, ["foo", "bar", "baz"])
  }

  func testJSONWithRootObject() {
    let object = JSONFromFile(file: "root_object") as? [String: AnyObject]
    let user: User? = object.flatMap { decode($0, rootKey: "user") }

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email != nil)
    XCTAssert(user?.email! == "u.cool@example.com")
  }

  func testDecodingNonFinalClass() {
    let object = JSONFromFile(file: "url") as? [String: AnyObject]
    let url: NSURL? = object.flatMap { decode($0, rootKey: "url") }

    XCTAssert(url != nil)
    XCTAssert(url?.absoluteString == "http://example.com")
  }

  func testDecodingJSONWithRootArray() {
    let expected = JSON([["title": "Foo", "age": 21], ["title": "Bar", "age": 32]])
    let json = JSONFromFile(file: "root_array").map(JSON.init)

    XCTAssert(.some(expected) == json)
  }

  func testFlatMapOptionals() {
    let json: AnyObject? = JSONFromFile(file: "user_with_email")
    let user: User? = json.flatMap(decode)

    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email == "u.cool@example.com")
  }
  
  func testNilCoalescing() {
    let json: AnyObject? = JSONFromFile(file: "user_with_nested_name")
    let user: User? = json.flatMap(decode)

    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Very Cool User")
    XCTAssert(user?.email == "u.cool@example.com")
  }

  func testFlatMapDecoded() {
    let json: AnyObject? = JSONFromFile(file: "user_with_email")
    let user: Decoded<User> = .fromOptional(json) >>- decode

    XCTAssert(user.value?.id == 1)
    XCTAssert(user.value?.name == "Cool User")
    XCTAssert(user.value?.email == "u.cool@example.com")
  }
}
