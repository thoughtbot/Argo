import XCTest
import Argo

final class EmbeddedDecodingTests: XCTestCase {
  func testDecodeEmbeddedObject() {
    let post: Decoded<LocationPost> = decode(json(fromFile: "location_post")!)

    switch post.value {
    case .some: XCTAssert(true)
    case .none: XCTFail("Unexpected Failure")
    }
  }

  func testDecodeEmbeddedOptionalObject() {
    let post: Decoded<LocationPost> = decode(json(fromFile: "bad_location_post")!)

    switch post.value {
    case .some: XCTAssert(true)
    case .none: XCTFail("Unexpected Failure")
    }
  }
}
