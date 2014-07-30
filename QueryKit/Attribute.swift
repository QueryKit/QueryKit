//
//  Attribute.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

public class Attribute<T> : Equatable {
    public let name:String

    public init(_ name:String) {
        self.name = name
    }

    /// Builds a compound attribute with other key paths
    public convenience init(attributes:Array<String>) {
        self.init(".".join(attributes))
    }

    // Sorting

    public var expression:NSExpression {
        return NSExpression(forKeyPath: name)
    }

    public func ascending() -> NSSortDescriptor {
        return NSSortDescriptor(key: name, ascending: true)
    }

    public func descending() -> NSSortDescriptor {
        return NSSortDescriptor(key: name, ascending: false)
    }
}

public @infix func == <T>(lhs: Attribute<T>, rhs: Attribute<T>) -> Bool {
    return lhs.name == rhs.name
}

public @infix func == <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression == NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

public @infix func != <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression != NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

public @infix func > <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression > NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

public @infix func >= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression >= NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

public @infix func < <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression < NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

public @infix func <= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression <= NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

// Bool Attributes

@prefix public func ! (left: Attribute<Bool>) -> NSPredicate {
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

// Collections

public func count(attribute:Attribute<NSSet>) -> Attribute<Int> {
    return Attribute<Int>(attributes: [attribute.name, "@count"])
}

public func count(attribute:Attribute<NSOrderedSet>) -> Attribute<Int> {
    return Attribute<Int>(attributes: [attribute.name, "@count"])
}
