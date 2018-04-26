import XCTest
import Argo

class OptionalPropertyDecodingTests: XCTestCase {
  func testUserDecodingWithEmail() {
    let user: User? = json(fromFile: "user_with_email").flatMap(decode)

    XCTAssertEqual(user?.id, 1)
    XCTAssertEqual(user?.name, "Cool User")
    XCTAssertEqual(user?.email!, "u.cool@example.com")
  }

  func testUserDecodingWithoutEmail() {
    let user: User? = json(fromFile: "user_without_email").flatMap(decode)

    XCTAssertEqual(user?.id, 1)
    XCTAssertEqual(user?.name, "Cool User")
    XCTAssertEqual(user?.email, nil)
  }
}
