//
//  AttributeTests.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import XCTest
import QueryKit

class AttributeTests: XCTestCase {
    var attribute:Attribute?

    override func setUp() {
        super.setUp()

        attribute = Attribute("age")
    }
    
    func testAttributeHasName() {
        XCTAssertEqual(attribute!.name, "age")
    }

    // Sorting

    func testAscendingSortDescriptor() {
        XCTAssertEqual(attribute!.ascending(), NSSortDescriptor(key: "age", ascending: true))
    }

    func testDescendingSortDescriptor() {
        XCTAssertEqual(attribute!.descending(), NSSortDescriptor(key: "age", ascending: false))
    }

    // Operators

    func testEqualityOperator() {
        var predicate:NSPredicate = (attribute! == 10)
        XCTAssertEqualObjects(predicate, NSPredicate(format:"age == 10"))
    }

    func testInequalityOperator() {
        var predicate:NSPredicate = (attribute! != 10)
        XCTAssertEqualObjects(predicate, NSPredicate(format:"age != 10"))
    }

    func testGreaterThanOperator() {
        var predicate:NSPredicate = (attribute! > 10)
        XCTAssertEqualObjects(predicate, NSPredicate(format:"age > 10"))
    }

    func testGreaterOrEqualThanOperator() {
        var predicate:NSPredicate = (attribute! >= 10)
        XCTAssertEqualObjects(predicate, NSPredicate(format:"age >= 10"))
    }

    func testLessThanOperator() {
        var predicate:NSPredicate = (attribute! < 10)
        XCTAssertEqualObjects(predicate, NSPredicate(format:"age < 10"))
    }

    func testLessOrEqualThanOperator() {
        var predicate:NSPredicate = (attribute! <= 10)
        XCTAssertEqualObjects(predicate, NSPredicate(format:"age <= 10"))
    }

    func testInOperator() {
        let predicate: NSPredicate = (attribute! *= [10, 20])
        let array: NSArray = [["age": 10], ["age": 20], ["age": 30]]
        let expected: NSArray = [["age": 10], ["age": 20]]
        XCTAssertEqualObjects(array.filteredArrayUsingPredicate(predicate), expected)
    }
    
    func testBetweenOperator() {
        let predicate: NSPredicate = (attribute! %= [10, 20])
        let array: NSArray = [["age": 10], ["age": 20], ["age": 30]]
        let expected: NSArray = [["age": 10], ["age": 20]]
        XCTAssertEqualObjects(array.filteredArrayUsingPredicate(predicate), expected)
    }
}
