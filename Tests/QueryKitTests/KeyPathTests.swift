import XCTest
@testable import QueryKit

class KeyPathTests: XCTestCase {
  func testEqualityOperator() {
    let predicate: Predicate<User> = \User.name == "kyle"
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"name == 'kyle'"))
  }

  func testEqualityOperatorWithOptional() {
    let predicate: Predicate<User> = \User.name == nil
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"name == %@", NSNull()))
  }

  func testOptionalEqualityOperatorWithOptional() {
    let predicate: Predicate<User> = \User.createdAt == nil
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"createdAt == %@", NSNull()))
  }

  func testInequalityOperator() {
    let predicate: Predicate<User> = \User.name != "kyle"
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"name != 'kyle'"))
  }

  func testInqqualityOperatorWithOptional() {
    let predicate: Predicate<User> = \User.name != nil
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"name != %@", NSNull()))
  }

  func testGreaterThanOperator() {
    let predicate: Predicate<User> = \User.age > 17
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"age > 17"))
  }

  func testGreaterThanOrEqualOperator() {
    let predicate: Predicate<User> = \User.age >= 18
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"age >= 18"))
  }

  func testLessThanOperator() {
    let predicate: Predicate<User> = \User.age < 18
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"age < 18"))
  }

  func testLessThanOrEqualOperator() {
    let predicate: Predicate<User> = \User.age <= 17
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"age <= 17"))
  }

  func testLikeOperator() {
    let predicate: Predicate<User> = \User.name ~= "k*"
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"name LIKE 'k*'"))
  }

  func testInOperator() {
    let predicate: Predicate<User> = \User.age << [5, 10]
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"age IN %@", [5, 10]))
  }

  func testBetweenRangeOperator() {
    let predicate: Predicate<User> = \User.age << (32 ..< 64)
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"age BETWEEN %@", [32, 64]))
  }
}

class KeyPathNSPredicateTests: XCTestCase {
  func testEqualityOperator() {
    let predicate: NSPredicate = \User.name == "kyle"
    XCTAssertEqual(predicate, NSPredicate(format:"name == 'kyle'"))
  }

  func testEqualityOperatorWithOptional() {
    let predicate: NSPredicate = \User.name == nil
    XCTAssertEqual(predicate, NSPredicate(format:"name == %@", NSNull()))
  }

  func testInequalityOperator() {
    let predicate: NSPredicate = \User.name != "kyle"
    XCTAssertEqual(predicate, NSPredicate(format:"name != 'kyle'"))
  }

  func testInqqualityOperatorWithOptional() {
    let predicate: NSPredicate = \User.name != nil
    XCTAssertEqual(predicate, NSPredicate(format:"name != %@", NSNull()))
  }

  func testGreaterThanOperator() {
    let predicate: NSPredicate = \User.age > 17
    XCTAssertEqual(predicate, NSPredicate(format:"age > 17"))
  }

  func testGreaterThanOrEqualOperator() {
    let predicate: NSPredicate = \User.age >= 18
    XCTAssertEqual(predicate, NSPredicate(format:"age >= 18"))
  }

  func testLessThanOperator() {
    let predicate: NSPredicate = \User.age < 18
    XCTAssertEqual(predicate, NSPredicate(format:"age < 18"))
  }

  func testLessThanOrEqualOperator() {
    let predicate: NSPredicate = \User.age <= 17
    XCTAssertEqual(predicate, NSPredicate(format:"age <= 17"))
  }

  func testLikeOperator() {
    let predicate: NSPredicate = \User.name ~= "k*"
    XCTAssertEqual(predicate, NSPredicate(format:"name LIKE 'k*'"))
  }

  func testInOperator() {
    let predicate: NSPredicate = \User.age << [5, 10]
    XCTAssertEqual(predicate, NSPredicate(format:"age IN %@", [5, 10]))
  }

  func testBetweenRangeOperator() {
    let predicate: NSPredicate = \User.age << (32 ..< 64)
    XCTAssertEqual(predicate, NSPredicate(format:"age BETWEEN %@", [32, 64]))
  }
}

class User: NSManagedObject {
  @objc var name: String?
  @NSManaged var age: Int
  @objc var createdAt: Date?
}
