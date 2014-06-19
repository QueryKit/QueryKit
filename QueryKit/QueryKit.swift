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

    let sortDescriptors = NSSortDescriptor[]()

    // Initialization

    init(_ context:NSManagedObjectContext, _ entityName:String) {
        self.context = context
        self.entityName = entityName
    }

    init(queryset:QuerySet, sortDescriptors:NSSortDescriptor[]?) {
        self.context = queryset.context
        self.entityName = queryset.entityName

        if let sortDescriptors = sortDescriptors {
            self.sortDescriptors = sortDescriptors
        }
    }

    // Sorting

    func orderBy(let sortDescriptor:NSSortDescriptor) -> QuerySet {
        return orderBy([sortDescriptor])
    }

    func orderBy(let sortDescriptors:NSSortDescriptor[]) -> QuerySet {
        return QuerySet(queryset:self, sortDescriptors:sortDescriptors)
    }
}
