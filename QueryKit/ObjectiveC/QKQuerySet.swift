import Foundation

extension QuerySet {
  public func asQKQuerySet() -> QKQuerySet {
    let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!

    var nsrange:NSRange = NSMakeRange(NSNotFound, NSNotFound)
    if let range = self.range {
      nsrange = NSMakeRange(range.startIndex, range.endIndex - range.startIndex)
    }

    return QKQuerySet(managedObjectContext: context, entityDescription: entityDescription, predicate: predicate, sortDescriptors: sortDescriptors, range:nsrange)
  }
}

extension QKQuerySet {
  public func asQuerySet() -> QuerySet<NSManagedObject> {
    var queryset = QuerySet<NSManagedObject>(managedObjectContext, entityDescription.name!)

    if let sortDescriptors = sortDescriptors as? [NSSortDescriptor] {
      queryset = queryset.orderBy(sortDescriptors)
    }

    if let predicate = predicate {
      queryset = queryset.filter(predicate)
    }

    if range.location != NSNotFound {
      queryset = queryset[range.location..<(range.location + range.length)]
    }

    return queryset
  }
}
