//
//  Expression.swift
//  QueryKit
//
//  Created by Kyle Fuller on 06/07/2014.
//
//

import Foundation

public func == (left: NSExpression, right: NSExpression) -> NSPredicate {
    return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.EqualToPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

public func != (left: NSExpression, right: NSExpression) -> NSPredicate {
    return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.NotEqualToPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

public func > (left: NSExpression, right: NSExpression) -> NSPredicate {
    return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.GreaterThanPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

public func >= (left: NSExpression, right: NSExpression) -> NSPredicate {
    return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.GreaterThanOrEqualToPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

public func < (left: NSExpression, right: NSExpression) -> NSPredicate {
    return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.LessThanPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

public func <= (left: NSExpression, right: NSExpression) -> NSPredicate {
    return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.LessThanOrEqualToPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

public func ~= (left: NSExpression, right: NSExpression) -> NSPredicate {
    return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.LikePredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

public func << (left: NSExpression, right: NSExpression) -> NSPredicate {
    return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.InPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}
