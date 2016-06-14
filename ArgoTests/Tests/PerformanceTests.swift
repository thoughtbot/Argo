import XCTest
import Argo

class PerformanceTests: XCTestCase {
  func testParsePerformance() {
    let json: AnyObject = JSONFromFile(file: "big_data")!

    measure {
      _ = JSON(json)
    }
  }

  func testDecodePerformance() {
    let json: AnyObject = JSONFromFile(file: "big_data")!
    let j = JSON(json)

    measure {
      _ = [TestModel].decode(j)
    }
  }

  func testBigDataDecodesCorrectly() {
    let json: AnyObject = JSONFromFile(file: "big_data")!
    let j = JSON(json)
    let models = [TestModel].decode(j)
    XCTAssertEqual(models.value!.count, 10_000, "Decoded big_data should have 10_000 results.")
  }
}
