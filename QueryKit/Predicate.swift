//
//  Predicate.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

@infix func && (left: NSPredicate, right: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [left, right])
}

@infix func || (left: NSPredicate, right: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [left, right])
}

@prefix func ! (left: NSPredicate) -> NSPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicateType.NotPredicateType, subpredicates: [left])
}
