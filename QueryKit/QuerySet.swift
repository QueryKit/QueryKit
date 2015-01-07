//
//  QuerySet.swift
//  QueryKit
//
//  Created by Kyle Fuller on 06/07/2014.
//
//

import Foundation
import CoreData


/// Represents a lazy database lookup for a set of objects.
public class QuerySet<T : NSManagedObject> : SequenceType, Equatable {
    /// Returns the managed object context that will be used to execute any requests.
    public let context:NSManagedObjectContext

    /// Returns the name of the entity the request is configured to fetch.
    public let entityName:String

    /// Returns the sort descriptors of the receiver.
    public let sortDescriptors = [NSSortDescriptor]()

    /// Returns the predicate of the receiver.
    public let predicate:NSPredicate?

    public let range:Range<Int>?

    // MARK: Initialization

    public init(_ context:NSManagedObjectContext, _ entityName:String) {
        self.context = context
        self.entityName = entityName
    }

    public init(queryset:QuerySet<T>, sortDescriptors:[NSSortDescriptor]?, predicate:NSPredicate?, range:Range<Int>?) {
        self.context = queryset.context
        self.entityName = queryset.entityName

        if let sortDescriptors = sortDescriptors {
            self.sortDescriptors = sortDescriptors
        }

        self.predicate = predicate
        self.range = range
    }

    // MARK: Sorting

    /// Returns a new QuerySet containing objects ordered by the given sort descriptor.
    public func orderBy(sortDescriptor:NSSortDescriptor) -> QuerySet<T> {
        return orderBy([sortDescriptor])
    }

    /// Returns a new QuerySet containing objects ordered by the given sort descriptors.
    public func orderBy(sortDescriptors:[NSSortDescriptor]) -> QuerySet<T> {
        return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:predicate, range:range)
    }

    /// Reverses the ordering of the QuerySet
    public func reverse() -> QuerySet<T> {
        return QuerySet(queryset:self, sortDescriptors:sortDescriptors.reverse(), predicate:predicate, range:range)
    }

    // MARK: Filtering

    /// Returns a new QuerySet containing objects that match the given predicate.
    public func filter(predicate:NSPredicate) -> QuerySet<T> {
        var futurePredicate = predicate

        if let existingPredicate = self.predicate {
            futurePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [existingPredicate, predicate])
        }

        return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:futurePredicate, range:range)
    }

    /// Returns a new QuerySet containing objects that match the given predicates.
    public func filter(predicates:[NSPredicate]) -> QuerySet<T> {
        let newPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
        return filter(newPredicate)
    }

    /// Returns a new QuerySet containing objects that exclude the given predicate.
    public func exclude(predicate:NSPredicate) -> QuerySet<T> {
        let excludePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.NotPredicateType, subpredicates: [predicate])
        return filter(excludePredicate)
    }

    /// Returns a new QuerySet containing objects that exclude the given predicates.
    public func exclude(predicates:[NSPredicate]) -> QuerySet<T> {
        let excludePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
        return exclude(excludePredicate)
    }

    // MARK: Subscripting

    public subscript(index: Int) -> (object:T?, error:NSError?) {
        get {
            var request = fetchRequest
            request.fetchOffset = index
            request.fetchLimit = 1

            var error:NSError?
            if let items = context.executeFetchRequest(request, error:&error) {
              return (object:items.first as T?, error:error)
            } else {
              return (object: nil, error: error)
            }
        }
    }

    /// Returns the object at the specified index.
    public subscript(index: Int) -> T? {
        get {
            return self[index].object
        }
    }

    public subscript(range:Range<Int>) -> QuerySet<T> {
        get {
            var fullRange = range

            if let currentRange = self.range {
                fullRange = Range<Int>(start: currentRange.startIndex + range.startIndex, end:  range.endIndex)
            }

            return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:predicate, range:fullRange)
        }
    }
  
    // Mark: Getters
    public var first: T? {
      get {
        return self[0].object
      }
    }
  

    // MARK: Conversion

    public var fetchRequest:NSFetchRequest {
        var request = NSFetchRequest(entityName:entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        if let range = range {
            request.fetchOffset = range.startIndex
            request.fetchLimit = range.endIndex - range.startIndex
        }

        return request
    }

    public func array() -> (objects:([T]?), error:NSError?) {
        var error:NSError?
        var objects = context.executeFetchRequest(fetchRequest, error:&error) as? [T]
        return (objects:objects, error:error)
    }

    public func array() -> [T]? {
        return array().objects
    }

    // MARK: Count

    public func count() -> (count:Int?, error:NSError?) {
        var error:NSError?
        var count:Int? = context.countForFetchRequest(fetchRequest, error: &error)

        if count! == NSNotFound {
            count = nil
        }

        return (count:count, error:error)
    }

    /// Returns the count of objects matching the QuerySet.
    public func count() -> Int? {
        return count().count
    }

    // MARK: Exists

    /** Returns true if the QuerySet contains any results, and false if not.
    :note: Returns nil if the operation could not be completed.
    */
    public func exists() -> Bool? {
        let result:Int? = count()

        if let result = result {
            return result > 0
        }

        return nil
    }

    // MARK: Deletion

    /// Deletes all the objects matching the QuerySet.
    public func delete() -> (count:Int, error:NSError?) {
        var result = array() as (objects:([T]?), error:NSError?)
        var deletedCount = 0

        if let objects = result.objects {
            for object in objects {
                context.deleteObject(object)
            }

            deletedCount = objects.count
        }

        return (count:deletedCount, error:result.error)
    }

    // MARK: Sequence

    public func generate() -> IndexingGenerator<Array<T>> {
        var result = self.array() as (objects:([T]?), error:NSError?)
        
        if let objects = result.objects {
            return objects.generate()
        }
        
        return [].generate()
    }
}

public func == <T : NSManagedObject>(lhs: QuerySet<T>, rhs: QuerySet<T>) -> Bool {
    let context = lhs.context == rhs.context
    let entityName = lhs.entityName == rhs.entityName
    let sortDescriptors = lhs.sortDescriptors == rhs.sortDescriptors
    let predicate = lhs.predicate == rhs.predicate
    let startIndex = lhs.range?.startIndex == rhs.range?.startIndex
    let endIndex = lhs.range?.endIndex == rhs.range?.endIndex
    return context && entityName && sortDescriptors && predicate && startIndex && endIndex
}
