//
//  QueryKit.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation
import CoreData

struct QuerySet {
    let context:NSManagedObjectContext
    let entityName:String

    // Initialization

    init(_ context:NSManagedObjectContext, _ entityName:String) {
        self.context = context
        self.entityName = entityName
    }
}
