import XCTest
import Argo

class DecodedTests: XCTestCase {
  func testDecodedSuccess() {
    let user: Decoded<User> = decode(json(fromFile: "user_with_email")!)

    switch user {
    case let .success(x): XCTAssert(user.description == "Success(\(x))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
  
  func testDecodedWithError() {
    let user: Decoded<User> = decode(json(fromFile: "user_with_bad_type")!)
    
    switch user.error {
    case .some: XCTAssert(true)
    case .none: XCTFail("Unexpected Success")
    }
  }
  
  func testDecodedWithNoError() {
    let user: Decoded<User> = decode(json(fromFile: "user_with_email")!)
    
    switch user.error {
    case .some: XCTFail("Unexpected Error Occurred")
    case .none: XCTAssert(true)
    }
  }

  func testDecodedTypeMissmatch() {
    let user: Decoded<User> = decode(json(fromFile: "user_with_bad_type")!)

    switch user {
    case let .failure(.typeMismatch(expected, actual)): XCTAssert(user.description == "Failure(TypeMismatch(Expected \(expected), got \(actual)))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }

  func testDecodedMissingKey() {
    let user: Decoded<User> = decode(json(fromFile: "user_without_key")!)

    switch user {
    case let .failure(.missingKey(s)): XCTAssert(user.description == "Failure(MissingKey(\(s)))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }

  func testDecodedCustomError() {
    let customError: Decoded<Dummy> = decode([:])

    switch customError {
    case let .failure(e): XCTAssert(e.description == "Custom(My Custom Error)")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
  
  func testDecodedMaterializeSuccess() {
    let user: Decoded<User> = decode(json(fromFile: "user_with_email")!)
    let materialized = materialize { user.value! }
    
    switch materialized {
    case let .success(x): XCTAssert(user.description == "Success(\(x))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
  
  func testDecodedMaterializeFailure() {
    let error = NSError(domain: "com.thoughtbot.Argo", code: 0, userInfo: nil)
    let materialized = materialize { throw error }
    
    switch materialized {
    case let .failure(e): XCTAssert(e.description == "Custom(\(error.description))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
  
  func testDecodedDematerializeSuccess() {
    let user: Decoded<User> = decode(json(fromFile: "user_with_email")!)
    
    do {
      _ = try user.dematerialize()
      XCTAssert(true)
    } catch {
      XCTFail("Unexpected Error Occurred")
    }
  }
  
  func testDecodedDematerializeTypeMismatch() {
    let user: Decoded<User> = decode(json(fromFile: "user_with_bad_type")!)
    
    do {
      _ = try user.dematerialize()
      XCTFail("Unexpected Success")
    } catch DecodeError.typeMismatch {
      XCTAssert(true)
    } catch DecodeError.missingKey {
      XCTFail("Unexpected Error Occurred")
    } catch {
      XCTFail("Unexpected Error Occurred")
    }
  }
  
  func testDecodedDematerializeMissingKey() {
    let user: Decoded<User> = decode(json(fromFile: "user_without_key")!)
    
    do {
      _ = try user.dematerialize()
      XCTFail("Unexpected Success")
    } catch DecodeError.missingKey {
      XCTAssert(true)
    } catch DecodeError.typeMismatch {
      XCTFail("Unexpected Error Occurred")
    } catch {
      XCTFail("Unexpected Error Occurred")
    }
  }

  func testDecodedOrWithSuccess() {
    let successUser: Decoded<User> = decode(json(fromFile: "user_with_email")!)
    let failedUser: Decoded<User> = decode(json(fromFile: "user_with_bad_type")!)

    let result = successUser.or(failedUser)

    switch result {
    case .success: XCTAssert(result.description == successUser.description)
    default: XCTFail("Unexpected Case Occurred")
    }
  }

  func testDecodedOrWithError() {
    let successUser: Decoded<User> = decode(json(fromFile: "user_with_email")!)
    let failedUser: Decoded<User> = decode(json(fromFile: "user_with_bad_type")!)

    let result = failedUser.or(successUser)

    switch result {
    case .success: XCTAssert(result.description == successUser.description)
    default: XCTFail("Unexpected Case Occurred")
    }
  }
}

private struct Dummy: Decodable {
  static func decode(_ json: JSON) -> Decoded<Dummy> {
    return .customError("My Custom Error")
  }
}
