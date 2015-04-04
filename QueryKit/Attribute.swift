//
//  Attribute.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

public struct Attribute<AttributeType> : Equatable {
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

  func expressionForValue(value:AttributeType) -> NSExpression {
    // TODO: Find a cleaner implementation
    if let value = value as? NSObject {
      return NSExpression(forConstantValue: value as NSObject)
    }

    if sizeof(value.dynamicType) == sizeof(uintptr_t) {
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

public func == <AttributeType>(lhs: Attribute<AttributeType>, rhs: Attribute<AttributeType>) -> Bool {
  return lhs.name == rhs.name
}

public func == <AttributeType>(left: Attribute<AttributeType>, right: AttributeType) -> NSPredicate {
  return left.expression == left.expressionForValue(right)
}

public func != <AttributeType>(left: Attribute<AttributeType>, right: AttributeType) -> NSPredicate {
  return left.expression != left.expressionForValue(right)
}

public func > <AttributeType>(left: Attribute<AttributeType>, right: AttributeType) -> NSPredicate {
  return left.expression > left.expressionForValue(right)
}

public func >= <AttributeType>(left: Attribute<AttributeType>, right: AttributeType) -> NSPredicate {
  return left.expression >= left.expressionForValue(right)
}

public func < <AttributeType>(left: Attribute<AttributeType>, right: AttributeType) -> NSPredicate {
  return left.expression < left.expressionForValue(right)
}

public func <= <AttributeType>(left: Attribute<AttributeType>, right: AttributeType) -> NSPredicate {
  return left.expression <= left.expressionForValue(right)
}

public func ~= <AttributeType>(left: Attribute<AttributeType>, right: AttributeType) -> NSPredicate {
  return left.expression ~= left.expressionForValue(right)
}

public func << <AttributeType>(left: Attribute<AttributeType>, right: [AttributeType]) -> NSPredicate {
  return left.expression << NSExpression(forConstantValue: right._asCocoaArray())
}

public func << <AttributeType>(left: Attribute<AttributeType>, right: Range<AttributeType>) -> NSPredicate {
  let rightExpression = NSExpression(forConstantValue: [right.startIndex, right.endIndex]._asCocoaArray())

  return NSComparisonPredicate(leftExpression: left.expression, rightExpression: rightExpression, modifier: NSComparisonPredicateModifier.DirectPredicateModifier, type: NSPredicateOperatorType.BetweenPredicateOperatorType, options: NSComparisonPredicateOptions(0))
}

/// MARK: Bool Attributes

prefix public func ! (left: Attribute<Bool>) -> NSPredicate {
  return left == false
}

public extension QuerySet {
  public func filter(attribute:Attribute<Bool>) -> QuerySet<ModelType> {
    return filter(attribute == true)
  }

  public func exclude(attribute:Attribute<Bool>) -> QuerySet<ModelType> {
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
