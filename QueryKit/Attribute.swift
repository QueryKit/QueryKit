//
//  Attribute.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

public struct Attribute<T> : Equatable {
    public let name:String

    public init(_ name:String) {
        self.name = name
    }

    /// Builds a compound attribute with other key paths
    public init(attributes:Array<String>) {
        self.init(".".join(attributes))
    }

    public var expression:NSExpression {
        return NSExpression(forKeyPath: name)
    }

    // MARK: Sorting

    public func ascending() -> NSSortDescriptor {
        return NSSortDescriptor(key: name, ascending: true)
    }

    public func descending() -> NSSortDescriptor {
        return NSSortDescriptor(key: name, ascending: false)
    }

    func expressionForValue(value:T) -> NSExpression {
        if let value = value as? NSObject {
            return NSExpression(forConstantValue: value as NSObject)
        }

        if sizeof(value.dynamicType) == 8 {
            let value = unsafeBitCast(value, Optional<NSObject>.self)
            if let value = value {
                return NSExpression(forConstantValue: value)
            }
        }

        let value = unsafeBitCast(value, Optional<String>.self)
        if let value = value {
            return NSExpression(forConstantValue: value)
        }

        return NSExpression(forConstantValue: NSNull())
    }
}

public func == <T>(lhs: Attribute<T>, rhs: Attribute<T>) -> Bool {
    return lhs.name == rhs.name
}

public func == <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression == left.expressionForValue(right)
}

public func != <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression != left.expressionForValue(right)
}

public func > <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression > left.expressionForValue(right)
}

public func >= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression >= left.expressionForValue(right)
}

public func < <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression < left.expressionForValue(right)
}

public func <= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression <= left.expressionForValue(right)
}

public func ~= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression ~= left.expressionForValue(right)
}

public func << <T>(left: Attribute<T>, right: [T]) -> NSPredicate {
    return left.expression << NSExpression(forConstantValue: right._asCocoaArray())
}

public func << <T>(left: Attribute<T>, right: Range<T>) -> NSPredicate {
    let rightExpression = NSExpression(forConstantValue: [right.startIndex, right.endIndex]._asCocoaArray())

    return NSComparisonPredicate(leftExpression: left.expression, rightExpression: rightExpression, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.BetweenPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

/// MARK: Bool Attributes

prefix public func ! (left: Attribute<Bool>) -> NSPredicate {
    return left == false
}

public extension QuerySet {
    public func filter(attribute:Attribute<Bool>) -> QuerySet<T> {
        return filter(attribute == true)
    }

    public func exclude(attribute:Attribute<Bool>) -> QuerySet<T> {
        return filter(attribute == false)
    }
}

// MARK: Collections

public func count(attribute:Attribute<NSSet>) -> Attribute<Int> {
    return Attribute<Int>(attributes: [attribute.name, "@count"])
}

public func count(attribute:Attribute<NSOrderedSet>) -> Attribute<Int> {
    return Attribute<Int>(attributes: [attribute.name, "@count"])
}
