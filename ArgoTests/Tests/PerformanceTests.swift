import XCTest
import Argo
import Runes

class PerformanceTests: XCTestCase {
  func testParsePerformance() {
    let json: AnyObject = JSONFileReader.JSON(fromFile: "big_data")!

    measureBlock {
      let j = JSON.parse(json)
    }
  }

  func testDecodePerformance() {
    let json: AnyObject = JSONFileReader.JSON(fromFile: "big_data")!
    let j = JSON.parse(json)

    measureBlock {
      let model: Decoded<[TestModel]> = j <|| "types"
    }
  }
}
