//
//  QueryKit.swift
//  QueryKit
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import Foundation
import CoreData

extension NSFetchRequest {
    convenience init(_ queryset:QuerySet)  {
        self.init(entityName: queryset.entityName)
        predicate = queryset.predicate
        sortDescriptors = queryset.sortDescriptors
    }
}

struct QuerySet {
    let context:NSManagedObjectContext
    let entityName:String

    let sortDescriptors = NSSortDescriptor[]()
    let predicate:NSPredicate?

    // Initialization

    init(_ context:NSManagedObjectContext, _ entityName:String) {
        self.context = context
        self.entityName = entityName
    }

    init(queryset:QuerySet, sortDescriptors:NSSortDescriptor[]?, predicate:NSPredicate?) {
        self.context = queryset.context
        self.entityName = queryset.entityName

        if let sortDescriptors = sortDescriptors {
            self.sortDescriptors = sortDescriptors
        }

        self.predicate = predicate
    }

    // Sorting

    func orderBy(sortDescriptor:NSSortDescriptor) -> QuerySet {
        return orderBy([sortDescriptor])
    }

    func orderBy(sortDescriptors:NSSortDescriptor[]) -> QuerySet {
        return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:predicate)
    }

    // Filtering

    func filter(predicate:NSPredicate) -> QuerySet {
        var futurePredicate = predicate

        if let existingPredicate = self.predicate {
            futurePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [existingPredicate, predicate])
        }

        return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:futurePredicate)
    }

    func filter(predicates:NSPredicate[]) -> QuerySet {
        let newPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
        return filter(newPredicate)
    }

    func exclude(predicate:NSPredicate) -> QuerySet {
        let excludePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.NotPredicateType, subpredicates: [predicate])
        return filter(excludePredicate)
    }

    func exclude(predicates:NSPredicate[]) -> QuerySet {
        let excludePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
        return exclude(excludePredicate)
    }

    // Subscripting

    subscript(index: Int) -> (object:NSManagedObject?, error:NSError?) {
        get {
            var fetchRequest = NSFetchRequest(self)
            fetchRequest.fetchOffset = index
            fetchRequest.fetchLimit = 1

            var error:NSError?
            let items = context.executeFetchRequest(fetchRequest, error:&error)

            return (object:items[0] as? NSManagedObject, error:error)
        }
    }

    subscript(index: Int) -> NSManagedObject? {
        get {
            return self[index].object
        }
    }
}
