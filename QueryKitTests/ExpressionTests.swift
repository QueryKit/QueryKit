//
//  ExpressionTests.swift
//  QueryKit
//
//  Created by Kyle Fuller on 06/07/2014.
//
//

import XCTest
import QueryKit

class ExpressionTests: XCTestCase {
    var leftHandSide:NSExpression!
    var rightHandSide:NSExpression!

    override func setUp() {
        super.setUp()

        leftHandSide = NSExpression(forKeyPath: "age")
        rightHandSide = NSExpression(forConstantValue: 10)
    }

    func testEqualityOperator() {
        XCTAssertEqualObjects(leftHandSide == rightHandSide, NSPredicate(format:"age == 10"))
    }

    func testInequalityOperator() {
        XCTAssertEqualObjects(leftHandSide != rightHandSide, NSPredicate(format:"age != 10"))
    }

    func testGreaterThanOperator() {
        let predicate:NSPredicate = leftHandSide > rightHandSide
        XCTAssertEqualObjects(predicate, NSPredicate(format:"age > 10"))
    }

    func testGreaterOrEqualThanOperator() {
        XCTAssertEqualObjects(leftHandSide >= rightHandSide, NSPredicate(format:"age >= 10"))
    }

    func testLessThanOperator() {
        XCTAssertEqualObjects(leftHandSide < rightHandSide, NSPredicate(format:"age < 10"))
    }

    func testLessOrEqualThanOperator() {
        XCTAssertEqualObjects(leftHandSide <= rightHandSide, NSPredicate(format:"age <= 10"))
    }
}
