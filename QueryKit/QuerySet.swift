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
public class QuerySet<ModelType : NSManagedObject> : SequenceType, Equatable {
  /// Returns the managed object context that will be used to execute any requests.
  public let context:NSManagedObjectContext

  /// Returns the name of the entity the request is configured to fetch.
  public let entityName:String

  /// Returns the sort descriptors of the receiver.
  public let sortDescriptors:[NSSortDescriptor]

  /// Returns the predicate of the receiver.
  public let predicate:NSPredicate?

  /// The range of the query, allows you to offset and limit a query
  public let range:Range<Int>?

  // MARK: Initialization

  public init(_ context:NSManagedObjectContext, _ entityName:String) {
    self.context = context
    self.entityName = entityName
    self.sortDescriptors = []
    self.predicate = nil
    self.range = nil
  }

  /// Create a queryset from another queryset with a different sortdescriptor predicate and range
  public init(queryset:QuerySet<ModelType>, sortDescriptors:[NSSortDescriptor]?, predicate:NSPredicate?, range:Range<Int>?) {
    self.context = queryset.context
    self.entityName = queryset.entityName
    self.sortDescriptors = sortDescriptors ?? []
    self.predicate = predicate
    self.range = range
  }
}

/// Methods which return a new queryset
extension QuerySet {
  // MARK: Sorting

  /// Returns a new QuerySet containing objects ordered by the given sort descriptor.
  public func orderBy(sortDescriptor:NSSortDescriptor) -> QuerySet<ModelType> {
    return orderBy([sortDescriptor])
  }

  /// Returns a new QuerySet containing objects ordered by the given sort descriptors.
  public func orderBy(sortDescriptors:[NSSortDescriptor]) -> QuerySet<ModelType> {
    return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:predicate, range:range)
  }

  /// Reverses the ordering of the QuerySet
  public func reverse() -> QuerySet<ModelType> {
    func reverseSortDescriptor(sortDescriptor:NSSortDescriptor) -> NSSortDescriptor {
      return NSSortDescriptor(key: sortDescriptor.key!, ascending: !sortDescriptor.ascending)
    }

    return QuerySet(queryset:self, sortDescriptors:sortDescriptors.map(reverseSortDescriptor), predicate:predicate, range:range)
  }

  // MARK: Filtering

  /// Returns a new QuerySet containing objects that match the given predicate.
  public func filter(predicate:NSPredicate) -> QuerySet<ModelType> {
    var futurePredicate = predicate

    if let existingPredicate = self.predicate {
      futurePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [existingPredicate, predicate])
    }

    return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:futurePredicate, range:range)
  }

  /// Returns a new QuerySet containing objects that match the given predicates.
  public func filter(predicates:[NSPredicate]) -> QuerySet<ModelType> {
    let newPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
    return filter(newPredicate)
  }

  /// Returns a new QuerySet containing objects that exclude the given predicate.
  public func exclude(predicate:NSPredicate) -> QuerySet<ModelType> {
    let excludePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.NotPredicateType, subpredicates: [predicate])
    return filter(excludePredicate)
  }

  /// Returns a new QuerySet containing objects that exclude the given predicates.
  public func exclude(predicates:[NSPredicate]) -> QuerySet<ModelType> {
    let excludePredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
    return exclude(excludePredicate)
  }
}

/// Functions for evauluating a QuerySet
extension QuerySet {
  // MARK: Subscripting

  /// Returns the object at the specified index.
  public func object(index: Int) throws -> ModelType? {
    let request = fetchRequest
    request.fetchOffset = index
    request.fetchLimit = 1
    let items = try context.executeFetchRequest(request)
    return items.first as? ModelType
  }

  public subscript(range:Range<Int>) -> QuerySet<ModelType> {
    get {
      var fullRange = range

      if let currentRange = self.range {
        fullRange = Range<Int>(start: currentRange.startIndex + range.startIndex, end:  range.endIndex)
      }

      return QuerySet(queryset:self, sortDescriptors:sortDescriptors, predicate:predicate, range:fullRange)
    }
  }

  // Mark: Getters

  /// Returns the first object in the QuerySet
  public func first() throws -> ModelType? {
    return try self.object(0)
  }

  /// Returns the last object in the QuerySet
  public func last() throws -> ModelType? {
    return try reverse().first()
  }

  // MARK: Conversion

  /// Returns a fetch request equivilent to the QuerySet
  public var fetchRequest:NSFetchRequest {
    let request = NSFetchRequest(entityName:entityName)
    request.predicate = predicate
    request.sortDescriptors = sortDescriptors

    if let range = range {
      request.fetchOffset = range.startIndex
      request.fetchLimit = range.endIndex - range.startIndex
    }

    return request
  }

  /// Returns an array of all objects matching the QuerySet
  public func array() throws -> [ModelType] {
    let objects = try context.executeFetchRequest(fetchRequest) as! [ModelType]
    return objects
  }

  // MARK: Count

  /// Returns the count of objects matching the QuerySet.
  public func count() throws -> Int {
    var error:NSError?
    let count:Int? = context.countForFetchRequest(fetchRequest, error: &error)

    if let error = error {
      throw error
    }

    return count as Int!
  }

  // MARK: Exists

  /** Returns true if the QuerySet contains any results, and false if not.
  :note: Returns nil if the operation could not be completed.
  */
  public func exists() throws -> Bool {
    let result:Int = try count()
    return result > 0
  }

  // MARK: Deletion

  /// Deletes all the objects matching the QuerySet.
  public func delete() throws -> Int {
    let objects = try array()
    let deletedCount = objects.count

    for object in objects {
      context.deleteObject(object)
    }

    return deletedCount
  }

  // MARK: Sequence

  public func generate() -> IndexingGenerator<Array<ModelType>> {
    do {
      let generator = try self.array().generate()
      return generator
    } catch {
      return [].generate()
    }
  }
}

/// Returns true if the two given querysets are equivilent
public func == <ModelType : NSManagedObject>(lhs: QuerySet<ModelType>, rhs: QuerySet<ModelType>) -> Bool {
  let context = lhs.context == rhs.context
  let entityName = lhs.entityName == rhs.entityName
  let sortDescriptors = lhs.sortDescriptors == rhs.sortDescriptors
  let predicate = lhs.predicate == rhs.predicate
  let startIndex = lhs.range?.startIndex == rhs.range?.startIndex
  let endIndex = lhs.range?.endIndex == rhs.range?.endIndex
  return context && entityName && sortDescriptors && predicate && startIndex && endIndex
}
