import CoreData

func expression<R, V>(for keyPath: KeyPath<R, V>) -> NSExpression {
  return NSExpression(forKeyPath: (keyPath as AnyKeyPath)._kvcKeyPathString!)
}

// MARK: Predicate

public func == <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> Predicate<R> {
  return Predicate(predicate: lhs == rhs)
}

public func != <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> Predicate<R> {
  return Predicate(predicate: lhs != rhs)
}

public func > <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> Predicate<R> {
  return Predicate(predicate: lhs > rhs)
}

public func >= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> Predicate<R> {
  return Predicate(predicate: lhs >= rhs)
}

public func < <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> Predicate<R> {
  return Predicate(predicate: lhs < rhs)
}

public func <= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> Predicate<R> {
  return Predicate(predicate: lhs <= rhs)
}

public func ~= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> Predicate<R> {
  return Predicate(predicate: lhs ~= rhs)
}

public func << <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: [V]) -> Predicate<R> {
  return Predicate(predicate: lhs << rhs)
}

public func << <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: Range<V>) -> Predicate<R> {
  return Predicate(predicate: lhs << rhs)
}

// MARK: - NSPredicate

public func == <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  return expression(for: lhs) == NSExpression(forConstantValue: rhs)
}

public func != <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  return expression(for: lhs) != NSExpression(forConstantValue: rhs)
}

public func > <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  return expression(for: lhs) > NSExpression(forConstantValue: rhs)
}

public func >= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  return expression(for: lhs) >= NSExpression(forConstantValue: rhs)
}

public func < <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  return expression(for: lhs) < NSExpression(forConstantValue: rhs)
}

public func <= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  return expression(for: lhs) <= NSExpression(forConstantValue: rhs)
}

public func ~= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  return expression(for: lhs) ~= NSExpression(forConstantValue: rhs)
}

public func << <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: [V]) -> NSPredicate {
  return expression(for: lhs) << NSExpression(forConstantValue: rhs)
}

public func << <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: Range<V>) -> NSPredicate {
  return expression(for: lhs) << NSExpression(forConstantValue: rhs)
}
