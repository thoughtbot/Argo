import XCTest
import Argo

class PerformanceTests: XCTestCase {
  func testParsePerformance() {
    let json: AnyObject = JSONFromFile("big_data")!

    measureBlock {
      JSON.parse(json)
    }
  }

  func testDecodePerformance() {
    let json: AnyObject = JSONFromFile("big_data")!
    let j = JSON.parse(json)

    measureBlock {
      [TestModel].decode(j)
    }
  }

  func testBigDataDecodesCorrectly() {
    let json: AnyObject = JSONFromFile("big_data")!
    let j = JSON.parse(json)
    let models = [TestModel].decode(j)
    XCTAssertEqual(models.value!.count, 10_000, "Decoded big_data should have 10_000 results.")
  }
}
