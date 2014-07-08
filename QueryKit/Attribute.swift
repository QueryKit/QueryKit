//
//  Attribute.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

class Attribute<T> : Equatable {
    let name:String

    init(_ name:String) {
        self.name = name
    }

    /// Builds a compound attribute with other key paths
    convenience init(attributes:Array<String>) {
        self.init(".".join(attributes))
    }

    // Sorting

    var expression:NSExpression {
        return NSExpression(forKeyPath: name)
    }

    func ascending() -> NSSortDescriptor {
        return NSSortDescriptor(key: name, ascending: true)
    }

    func descending() -> NSSortDescriptor {
        return NSSortDescriptor(key: name, ascending: false)
    }
}

func == <T>(lhs: Attribute<T>, rhs: Attribute<T>) -> Bool {
    return lhs.name == rhs.name
}

@infix func == <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression == NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

@infix func != <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression != NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

@infix func > <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression > NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

@infix func >= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression >= NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

@infix func < <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression < NSExpression(forConstantValue: bridgeToObjectiveC(right))
}

@infix func <= <T>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression <= NSExpression(forConstantValue: bridgeToObjectiveC(right))
}
