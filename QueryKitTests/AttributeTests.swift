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
    var attribute:Attribute<Int>!

    override func setUp() {
        super.setUp()

        attribute = Attribute("age")
    }
    
    func testAttributeHasName() {
        XCTAssertEqual(attribute.name, "age")
    }

    func testAttributeExpression() {
        XCTAssertEqual(attribute.expression.keyPath!, "age")
    }

    func testEqualAttributesAreEquatable() {
        XCTAssertEqual(attribute, Attribute<Int>("age"))
    }

    func testCompoundAttributeCreation() {
        let personCompanyNameAttribute = Attribute<NSString>(attributes:["company", "name"])

        XCTAssertEqual(personCompanyNameAttribute.name, "company.name")
        XCTAssertEqual(personCompanyNameAttribute.expression.keyPath!, "company.name")
    }

    // Sorting

    func testAscendingSortDescriptor() {
        XCTAssertEqual(attribute.ascending(), NSSortDescriptor(key: "age", ascending: true))
    }

    func testDescendingSortDescriptor() {
        XCTAssertEqual(attribute.descending(), NSSortDescriptor(key: "age", ascending: false))
    }

    // Operators

    func testEqualityOperator() {
        var predicate:NSPredicate = (attribute == 10)
        XCTAssertEqual(predicate, NSPredicate(format:"age == 10"))
    }

    func testInequalityOperator() {
        var predicate:NSPredicate = (attribute != 10)
        XCTAssertEqual(predicate, NSPredicate(format:"age != 10"))
    }

    func testGreaterThanOperator() {
        var predicate:NSPredicate = (attribute > 10)
        XCTAssertEqual(predicate, NSPredicate(format:"age > 10"))
    }

    func testGreaterOrEqualThanOperator() {
        var predicate:NSPredicate = (attribute >= 10)
        XCTAssertEqual(predicate, NSPredicate(format:"age >= 10"))
    }

    func testLessThanOperator() {
        var predicate:NSPredicate = (attribute < 10)
        XCTAssertEqual(predicate, NSPredicate(format:"age < 10"))
    }

    func testLessOrEqualThanOperator() {
        var predicate:NSPredicate = (attribute <= 10)
        XCTAssertEqual(predicate, NSPredicate(format:"age <= 10"))
    }
}

class CollectionAttributeTests: XCTestCase {
    func testCountOfSet() {
        let setAttribute = Attribute<NSSet>("names")
        let countAttribute = count(setAttribute)
        XCTAssertEqual(countAttribute, Attribute<Int>("names.@count"))
    }

    func testCountOfOrderedSet() {
        let setAttribute = Attribute<NSOrderedSet>("names")
        let countAttribute = count(setAttribute)
        XCTAssertEqual(countAttribute, Attribute<Int>("names.@count"))
    }
}

class BoolAttributeTests: XCTestCase {
    var attribute:Attribute<Bool>!

    override func setUp() {
        super.setUp()
        attribute = Attribute("hasName")
    }

    func testNotAttributeReturnsPredicate() {
        XCTAssertEqual(!attribute, NSPredicate(format:"hasName == NO"))
    }
}
