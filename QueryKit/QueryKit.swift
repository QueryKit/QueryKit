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

        if let range = queryset.range {
            fetchOffset = range.startIndex
            fetchLimit = range.endIndex - range.startIndex
        }
    }
}

struct QuerySet {
    let context:NSManagedObjectContext
    let entityName:String

    let sortDescriptors = NSSortDescriptor[]()
    let predicate:NSPredicate?
    let range:Range<Int>?

    // Initialization

    init(_ context:NSManagedObjectContext, _ entityName:String) {
        self.context = context
        self.entityName = entityName
    }

    init(queryset:QuerySet, sortDescriptors:NSSortDescriptor[]?, predicate:NSPredicate?, range:Range<Int>?) {
        self.context = queryset.context
        self.entityName = queryset.entityName

        if let sortDescriptors = sortDescriptors {
            self.sortDescriptors = sortDescriptors
        }

        self.predicate = predicate
        self.range = range
    }

    // Sorting

    func orderBy(sortDescriptor:NSSortDescriptor) -> QuerySet {
        return orderBy([sortDescriptor])
    }

    func orderBy(sortDescriptors:NSSortDescriptor[]) -> QuerySet {
        return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:predicate, range:range)
    }

    // Filtering

    func filter(predicate:NSPredicate) -> QuerySet {
        var futurePredicate = predicate

        if let existingPredicate = self.predicate {
            futurePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [existingPredicate, predicate])
        }

        return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:futurePredicate, range:range)
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

    subscript(range:Range<Int>) -> QuerySet {
        get {
            var fullRange = range

            if let currentRange = self.range {
                fullRange = Range<Int>(start: currentRange.startIndex + range.startIndex, end:  range.endIndex)
            }

            return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:predicate, range:fullRange)
        }
    }

    // Conversion

    func array() -> (objects:(NSManagedObject[]?), error:NSError?) {
        var fetchRequest = NSFetchRequest(self)
        var error:NSError?
        var objects = context.executeFetchRequest(fetchRequest, error:&error) as? NSManagedObject[]
        return (objects:objects, error:error)
    }

    func array() -> NSManagedObject[]? {
        return array().objects
    }

    // Count

    func count() -> (count:Int, error:NSError?) {
        var fetchRequest = NSFetchRequest(self)
        var error:NSError?
        var count = context.countForFetchRequest(fetchRequest, error: &error)
        return (count:count, error:error)
    }

    func count() -> Int {
        return count().count
    }

    // Deletion

    func delete() -> (count:Int, error:NSError?) {
        var result = array() as (objects:(NSManagedObject[]?), error:NSError?);
        var deletedCount = 0

        if let objects = result.objects {
            for object in objects {
                context.deleteObject(object)
            }

            deletedCount = objects.count
        }

        return (count:deletedCount, error:result.error)
    }
}
