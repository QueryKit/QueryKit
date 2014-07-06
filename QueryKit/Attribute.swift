//
//  Attribute.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

class Attribute<T> {
    let name:String

    init(_ name:String) {
        self.name = name
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

@infix func == <T : AnyObject>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression == NSExpression(forConstantValue: right)
}

@infix func != <T : AnyObject>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression != NSExpression(forConstantValue: right)
}

@infix func > <T : AnyObject>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression > NSExpression(forConstantValue: right)
}

@infix func >= <T : AnyObject>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression >= NSExpression(forConstantValue: right)
}

@infix func < <T : AnyObject>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression < NSExpression(forConstantValue: right)
}

@infix func <= <T : AnyObject>(left: Attribute<T>, right: T) -> NSPredicate {
    return left.expression <= NSExpression(forConstantValue: right)
}
