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
      j <|| "types" as Decoded<[TestModel]>
    }
  }
}
