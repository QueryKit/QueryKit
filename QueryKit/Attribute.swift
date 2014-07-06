//
//  Attribute.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation


enum CaseSensitivity {
    case Insensitive, Sensitive, DiacriticSensitive

    func simpleDescription() -> String {
        switch self {
        case .Insensitive:
            return ""
        case .Sensitive:
            return "[c]"
        case .DiacriticSensitive:
            return "[cd]"
        }
    }
}

class Attribute {
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

@infix func == (left: Attribute, right: AnyObject) -> NSPredicate {
    return left.expression == NSExpression(forConstantValue: right)
}

@infix func != (left: Attribute, right: AnyObject) -> NSPredicate {
    return left.expression != NSExpression(forConstantValue: right)
}

@infix func > (left: Attribute, right: AnyObject) -> NSPredicate {
    return left.expression > NSExpression(forConstantValue: right)
}

@infix func >= (left: Attribute, right: AnyObject) -> NSPredicate {
    return left.expression >= NSExpression(forConstantValue: right)
}

@infix func < (left: Attribute, right: AnyObject) -> NSPredicate {
    return left.expression < NSExpression(forConstantValue: right)
}

@infix func <= (left: Attribute, right: AnyObject) -> NSPredicate {
    return left.expression <= NSExpression(forConstantValue: right)
}

@infix func << (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K IN %@", argumentArray: [left.name, right])
}

@infix func << (left: Attribute, right: (AnyObject, AnyObject)) -> NSPredicate {
    return NSPredicate(format: "%K BETWEEN %@", argumentArray: [left.name, [right.0, right.1]])
}

@infix func ~= (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K LIKE %@", argumentArray: [left.name, right])
}

@infix func ~= (left: Attribute, right: (AnyObject, CaseSensitivity)) -> NSPredicate {
    var formatString = "%K LIKE\(right.1.simpleDescription()) %@"

    return NSPredicate(format: formatString, argumentArray: [left.name, right.0])
}
