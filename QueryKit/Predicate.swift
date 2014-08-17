//
//  Predicate.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

public func && (left: NSPredicate, right: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [left, right])
}

public func || (left: NSPredicate, right: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [left, right])
}

prefix public func ! (left: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicateType.NotPredicateType, subpredicates: [left])
}
