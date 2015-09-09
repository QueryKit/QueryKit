import Foundation

/// Returns an equality predicate for the two given expressions
public func == (left: NSExpression, right: NSExpression) -> NSPredicate {
  return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.EqualToPredicateOperatorType, options: NSComparisonPredicateOptions(rawValue: 0))
}

/// Returns an inequality predicate for the two given expressions
public func != (left: NSExpression, right: NSExpression) -> NSPredicate {
  return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.NotEqualToPredicateOperatorType, options: NSComparisonPredicateOptions(rawValue: 0))
}

public func > (left: NSExpression, right: NSExpression) -> NSPredicate {
  return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.GreaterThanPredicateOperatorType, options: NSComparisonPredicateOptions(rawValue: 0))
}

public func >= (left: NSExpression, right: NSExpression) -> NSPredicate {
  return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.GreaterThanOrEqualToPredicateOperatorType, options: NSComparisonPredicateOptions(rawValue: 0))
}

public func < (left: NSExpression, right: NSExpression) -> NSPredicate {
  return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.LessThanPredicateOperatorType, options: NSComparisonPredicateOptions(rawValue: 0))
}

public func <= (left: NSExpression, right: NSExpression) -> NSPredicate {
  return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.LessThanOrEqualToPredicateOperatorType, options: NSComparisonPredicateOptions(rawValue: 0))
}

public func ~= (left: NSExpression, right: NSExpression) -> NSPredicate {
  return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.LikePredicateOperatorType, options: NSComparisonPredicateOptions(rawValue: 0))
}

public func << (left: NSExpression, right: NSExpression) -> NSPredicate {
  return NSComparisonPredicate(leftExpression: left, rightExpression: right, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.InPredicateOperatorType, options: NSComparisonPredicateOptions(rawValue: 0))
}
