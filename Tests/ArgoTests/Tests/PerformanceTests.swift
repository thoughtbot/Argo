import XCTest
import Argo

class PerformanceTests: XCTestCase {
  func testParsePerformance() {
    let obj: Any = json(fromFile: "big_data")!

    measure {
      _ = JSON(obj)
    }
  }

  func testDecodePerformance() {
    let obj: Any = json(fromFile: "big_data")!
    let j = JSON(obj)

    measure {
      _ = [TestModel].decode(j)
    }
  }

  func testBigDataDecodesCorrectly() {
    let obj: Any = json(fromFile: "big_data")!
    let j = JSON(obj)
    let models = [TestModel].decode(j)
    XCTAssertEqual(models.value!.count, 10_000, "Decoded big_data should have 10_000 results.")
  }
}
