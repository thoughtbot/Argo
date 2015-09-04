import XCTest
import Argo

class DecodedTests: XCTestCase {
  func testDecodedSuccess() {
    let user: Decoded<User> = decode(JSONFromFile("user_with_email")!)

    switch user {
    case let .Success(x): XCTAssert(user.description == "Success(\(x))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }

  func testDecodedTypeMissmatch() {
    let user: Decoded<User> = decode(JSONFromFile("user_with_bad_type")!)

    switch user {
    case let .Failure(.TypeMismatch(expected, actual)): XCTAssert(user.description == "Failure(TypeMismatch(Expected \(expected), got \(actual)))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }

  func testDecodedMissingKey() {
    let user: Decoded<User> = decode(JSONFromFile("user_without_key")!)

    switch user {
    case let .Failure(.MissingKey(s)): XCTAssert(user.description == "Failure(MissingKey(\(s)))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
}
