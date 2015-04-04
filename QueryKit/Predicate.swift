//
//  Predicate.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

/// Returns an and predicate from the given predicates
public func && (left: NSPredicate, right: NSPredicate) -> NSPredicate {
  return NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [left, right])
}

/// Returns an or predicate from the given predicates
public func || (left: NSPredicate, right: NSPredicate) -> NSPredicate {
  return NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: [left, right])
}

/// Returns a predicate reversing the given predicate
prefix public func ! (left: NSPredicate) -> NSPredicate {
  return NSCompoundPredicate(type: NSCompoundPredicateType.NotPredicateType, subpredicates: [left])
}
