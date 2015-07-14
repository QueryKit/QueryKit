//
//  PredicateTests.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import XCTest
import QueryKit

class PredicateTests: XCTestCase {
    var namePredicate = NSPredicate(format: "name == Kyle")
    var agePredicate = NSPredicate(format: "age >= 21")

    func testAndPredicate() {
        let predicate = namePredicate && agePredicate
        XCTAssertEqual(predicate, NSPredicate(format: "name == Kyle AND age >= 21"))
    }

    func testOrPredicate() {
        let predicate = namePredicate || agePredicate
        XCTAssertEqual(predicate, NSPredicate(format: "name == Kyle OR age >= 21"))
    }

    func testNotPredicate() {
        let predicate = !namePredicate
        XCTAssertEqual(predicate, NSPredicate(format: "NOT name == Kyle"))
    }
}
