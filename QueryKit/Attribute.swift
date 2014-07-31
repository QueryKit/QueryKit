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

public func == <T>(lhs: Attribute<T>, rhs: Attribute<T>) -> Bool {
    return lhs.name == rhs.name
}

private func bridgeToObjC<T>(value: T) -> NSObject? {
    if value as? NSObject {
        return (value as NSObject) // This seems to always fail in Xcode 6 beta 4 ??
    }
    if value as? Int {
        return value as Int as NSObject
    }
    if value as? Bool {
        return value as Bool as NSObject
    }
    println("\(value) not convertible to Objective-C")
    return nil
}
private func bridgeToObjCAndCompare<T>(left: Attribute<T>, right: T, compare: (NSExpression,NSExpression) -> NSPredicate) -> NSPredicate! {
    if let obj = bridgeToObjC(right) {
        return compare(left.expression, NSExpression(forConstantValue: obj))
    }
    return nil
}

@infix public func == <T>(left: Attribute<T>, right: T) -> NSPredicate! {
    return bridgeToObjCAndCompare(left, right, ==)
}

@infix public func != <T>(left: Attribute<T>, right: T) -> NSPredicate! {
    return bridgeToObjCAndCompare(left, right, !=)
}

@infix public func > <T>(left: Attribute<T>, right: T) -> NSPredicate! {
    return bridgeToObjCAndCompare(left, right, >)
}

@infix public func >= <T>(left: Attribute<T>, right: T) -> NSPredicate! {
    return bridgeToObjCAndCompare(left, right, >=)
}

@infix public func < <T>(left: Attribute<T>, right: T) -> NSPredicate! {
    return bridgeToObjCAndCompare(left, right, <)
}

@infix public func <= <T>(left: Attribute<T>, right: T) -> NSPredicate! {
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
