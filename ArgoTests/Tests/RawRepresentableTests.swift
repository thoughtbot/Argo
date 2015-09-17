import XCTest
import Argo

enum TestRawString: String {
  case CoolString
  case NotCoolStringBro
}

enum TestRawInt: Int {
  case Zero
  case One
}

extension TestRawString: Decodable { }
extension TestRawInt: Decodable { }

class RawRepresentable: XCTestCase {
  func testStringEnum() {
    let json = JSON.Object([
      "string": JSON.String("CoolString"),
      "another": JSON.String("NotCoolStringBro")
      ])

    let string: TestRawString? = json <| "string"
    let another: TestRawString? = json <| "another"
    XCTAssert(TestRawString.CoolString == string)
    XCTAssert(TestRawString.NotCoolStringBro == another)
  }

  func testIntEnum() {
    let json = JSON.Object([
      "zero": JSON.Number(0),
      "one": JSON.Number(1)
      ])

    let zero: TestRawInt? = json <| "zero"
    let one: TestRawInt? = json <| "one"
    XCTAssert(TestRawInt.Zero == zero)
    XCTAssert(TestRawInt.One == one)
  }
}
