//
//  XCTAssertiOSFix.swift
//  QueryKit
//
//  Created by Konstantin Koval on 24/12/14.
//
//

import Foundation
import XCTest

func XCTAssertEqual(expression1: @autoclosure () -> String, expression2: @autoclosure () -> String) {
  XCTAssertEqual(expression1, expression2)
}

func XCTAssertEqual(expression1: @autoclosure () -> NSPredicate, expression2: @autoclosure () -> NSPredicate) {
  XCTAssertEqual(expression1, expression2)
}
