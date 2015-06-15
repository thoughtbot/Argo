import XCTest
import Argo

class DecodedErrorTests: XCTestCase {
  func testDecodedTypeMissmatch() {
    do {
      try decode(JSONFromFile("user_with_bad_type")!) as User
    } catch let error as DecodedError {
      print(error)
      switch error {
      case let .TypeMismatch(s): XCTAssert(error.description == "TypeMismatch(\(s))")
      default: XCTFail("Unexpected Case Occurred")
      }
    } catch {
      XCTFail()
    }
  }

  func testDecodedMissingKey() {
    do {
      try decode(JSONFromFile("user_without_key")!) as User
    } catch let error as DecodedError {
      switch error {
      case let .MissingKey(s): XCTAssert(error.description == "MissingKey(\(s))")
      default: XCTFail("Unexpected Case Occurred")
      }
    } catch {
      XCTFail()
    }
  }
}
