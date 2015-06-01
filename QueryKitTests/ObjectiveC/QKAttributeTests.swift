//
//  QKAttributeTests.swift
//  QueryKit
//
//  Created by Kyle Fuller on 23/08/2014.
//
//

import XCTest
import QueryKit

class QKAttributeTests: XCTestCase {
  var attribute:QKAttribute!

  override func setUp() {
    super.setUp()

    attribute = QKAttribute(name: "age")
  }

  func testAttributeHasName() {
    XCTAssertEqual(attribute.name, "age")
  }

  func testAttributeExpression() {
    XCTAssertEqual(attribute.expression().keyPath, "age")
  }

  func testEqualAttributesAreEquatable() {
    XCTAssertEqual(attribute, QKAttribute(name: "age"))
  }

  // MARK: Conversion

  func testConvertingAttributeToQKAttribute() {
    let qkAttribute = Attribute<String>("age").asQKAttribute()
    XCTAssertEqual(qkAttribute, attribute)
  }

  func testConvertingQKAttributeToAttribute() {
    XCTAssertEqual(attribute.asAttribute(), Attribute<AnyObject>("age"))
  }

  // MARK: Ordering

  func testAscendingSortDescriptor() {
    XCTAssertEqual(attribute.ascending(), NSSortDescriptor(key: "age", ascending: true))
  }

  func testDescendingSortDescriptor() {
    XCTAssertEqual(attribute.descending(), NSSortDescriptor(key: "age", ascending: false))
  }

  // MARK: Operators

  func testEqualityOperator() {
    let predicate = attribute.equal(10)
    XCTAssertEqual(predicate, NSPredicate(format:"age == 10"))
  }

  func testInequalityOperator() {
    let predicate = attribute.notEqual(10)
    XCTAssertEqual(predicate, NSPredicate(format:"age != 10"))
  }

  func testGreaterThanOperator() {
    let predicate = attribute.greaterThan(10)
    XCTAssertEqual(predicate, NSPredicate(format:"age > 10"))
  }

  func testGreaterOrEqualThanOperator() {
    let predicate = attribute.greaterThanOrEqualTo(10)
    XCTAssertEqual(predicate, NSPredicate(format:"age >= 10"))
  }

  func testLessThanOperator() {
    let predicate = attribute.lessThan(10)
    XCTAssertEqual(predicate, NSPredicate(format:"age < 10"))
  }

  func testLessOrEqualThanOperator() {
    let predicate = attribute.lessThanOrEqualTo(10)
    XCTAssertEqual(predicate, NSPredicate(format:"age <= 10"))
  }
}
