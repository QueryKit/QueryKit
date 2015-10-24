//
//  PredicateTests.swift
//  QueryKit
//
//  Created by Alexsander Akers on 01/10/2015.
//
//

import XCTest
@testable import QueryKit


class PredicateFormatTests: XCTestCase {
  func testWithOnlyString() {
    let predicate = Predicate<NSManagedObject>("TRUEPREDICATE")
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"TRUEPREDICATE"))
  }

  func testWithQuoted() {
    let attribute = Attribute<String>("name")
    let name = "QueryKit"

    let predicate = Predicate<NSManagedObject>("\(attribute) == \(quoted(name))")
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"name == \"QueryKit\""))
  }

  func testWithKey() {
    let attributeName = "name"
    let name = PredicateFormat.ObjectExpression("QueryKit")

    let predicate = Predicate<NSManagedObject>("\(key(attributeName)) == \(name)")
    XCTAssertEqual(predicate.predicate, NSPredicate(format:"name == \"QueryKit\""))
  }

  func testPredicateEquality() {
    let age = "age"
    let number = 21

    let value: PredicateFormat = "\(key(age)) == \(number)"
    let expected = PredicateFormat.Tree([.FormatSegment(""), .KeyPath("age"), .FormatSegment(" == "), .ObjectExpression(21), .FormatSegment("")])
    XCTAssertEqual(value, expected)
  }
}
