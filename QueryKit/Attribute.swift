//
//  Attribute.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation

class Attribute {
    let name:String

    init(_ name:String) {
        self.name = name
    }

    // Sorting

    func ascending() -> NSSortDescriptor {
        return NSSortDescriptor(key: name, ascending: true)
    }

    func descending() -> NSSortDescriptor {
        return NSSortDescriptor(key: name, ascending: false)
    }
}

@infix func == (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K == %@", argumentArray: [left.name, right])
}

@infix func != (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K != %@", argumentArray: [left.name, right])
}

@infix func > (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K > %@", argumentArray: [left.name, right])
}

@infix func >= (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K >= %@", argumentArray: [left.name, right])
}

@infix func < (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K < %@", argumentArray: [left.name, right])
}

@infix func <= (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K <= %@", argumentArray: [left.name, right])
}

@infix func *= (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K IN %@", argumentArray: [left.name, right])
}

@infix func %= (left: Attribute, right: AnyObject) -> NSPredicate {
    return NSPredicate(format: "%K BETWEEN %@", argumentArray: [left.name, right])
}

