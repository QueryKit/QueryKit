//
//  Attribute.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

public protocol NSObjectConvertible {
    func toNSObject() -> NSObject
}
extension Int: NSObjectConvertible {
    public func toNSObject() -> NSObject {
        return self as NSObject
    }
}
extension Bool: NSObjectConvertible {
    public func toNSObject() -> NSObject {
        return self as NSObject
    }
}
extension NSObject: NSObjectConvertible {
    public func toNSObject() -> NSObject {
        return self
    }
}

public class Attribute<T: NSObjectConvertible> : Equatable {
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

public func == <T>(lhs: Attribute<T>, rhs: Attribute<T>) -> Bool {
    return lhs.name == rhs.name
}

private func bridgeToObjCAndCompare<T>(left: Attribute<T>, right: T, compare: (NSExpression,NSExpression) -> NSPredicate) -> NSPredicate {
    return compare(left.expression, NSExpression(forConstantValue: right.toNSObject()))
}

@infix public func == <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return bridgeToObjCAndCompare(left, right, ==)
}

@infix public func != <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return bridgeToObjCAndCompare(left, right, !=)
}

@infix public func > <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return bridgeToObjCAndCompare(left, right, >)
}

@infix public func >= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return bridgeToObjCAndCompare(left, right, >=)
}

@infix public func < <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return bridgeToObjCAndCompare(left, right, <)
}

@infix public func <= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return bridgeToObjCAndCompare(left, right, <=)
}

// Bool Attributes

@prefix public func ! (left: Attribute<Bool>) -> NSPredicate {
    return (left == false) as NSPredicate
}

extension QuerySet {
    public func filter(attribute:Attribute<Bool>) -> QuerySet<T> {
        let pred: NSPredicate = (attribute == true)
        return filter(pred)
    }

    public func exclude(attribute:Attribute<Bool>) -> QuerySet<T> {
        let pred: NSPredicate = (attribute == false)
        return filter(pred)
    }
}

// Collections

public func count(attribute:Attribute<NSSet>) -> Attribute<Int> {
    return Attribute<Int>(attributes: [attribute.name, "@count"])
}

public func count(attribute:Attribute<NSOrderedSet>) -> Attribute<Int> {
    return Attribute<Int>(attributes: [attribute.name, "@count"])
}
