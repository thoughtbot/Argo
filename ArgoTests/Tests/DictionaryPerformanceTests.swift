import XCTest
import Argo
import Runes

class DictionaryPerformanceTests: XCTestCase {
  func testJSONParse() {
    let json: AnyObject = JSONFileReader.JSON(fromFile: "big_data")!

    measureBlock {
      let j = JSON.parse(json)
    }
  }
}
