import XCTest
import Argo

class OptionalPropertyDecodingTests: XCTestCase {
  func testUserDecodingWithEmail() {
    let user: User? = json(fromFile: "user_with_email").flatMap(decode)

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email != nil)
    XCTAssert(user?.email! == "u.cool@example.com")
  }

  func testUserDecodingWithoutEmail() {
    let user: User? = json(fromFile: "user_without_email").flatMap(decode)

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email == nil)
  }
}
