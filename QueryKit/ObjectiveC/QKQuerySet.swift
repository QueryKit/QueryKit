import Foundation

extension QuerySet {
    public func asQKQuerySet() -> QKQuerySet {
        let entityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        entityDescription
        return QKQuerySet(managedObjectContext: context, entityDescription: entityDescription, predicate: predicate, sortDescriptors: sortDescriptors)
    }
}

extension QKQuerySet {
    public func asQuerySet() -> QuerySet<NSManagedObject> {
        let queryset = QuerySet<NSManagedObject>(managedObjectContext, entityDescription.name)
        return queryset.orderBy(sortDescriptors as [NSSortDescriptor]).filter(predicate)
    }
}
