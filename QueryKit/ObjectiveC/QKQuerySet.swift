import Foundation

extension QuerySet {
    public func asQKQuerySet() -> QKQuerySet {
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)

        var nsrange:NSRange = NSMakeRange(NSNotFound, NSNotFound)
        if let range = self.range {
            nsrange = NSMakeRange(range.startIndex, range.endIndex - range.startIndex)
        }

        return QKQuerySet(managedObjectContext: context, entityDescription: entityDescription, predicate: predicate, sortDescriptors: sortDescriptors, range:nsrange)
    }
}

extension QKQuerySet {
    public func asQuerySet() -> QuerySet<NSManagedObject> {
        let queryset = QuerySet<NSManagedObject>(managedObjectContext, entityDescription.name!)
            .orderBy(sortDescriptors as [NSSortDescriptor])
            .filter(predicate)

        if range.location != NSNotFound {
            return queryset[range.location..<(range.location + range.length)]
        }

        return queryset
    }
}
