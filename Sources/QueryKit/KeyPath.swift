import CoreData

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
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute == rhs
}

public func != <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute != rhs
}

public func > <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute > rhs
}

public func >= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute >= rhs
}

public func < <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute < rhs
}

public func <= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute <= rhs
}

public func ~= <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: V) -> NSPredicate {
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute ~= rhs
}

public func << <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: [V]) -> NSPredicate {
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute << rhs
}

public func << <R : NSManagedObject, V>(lhs: KeyPath<R, V>, rhs: Range<V>) -> NSPredicate {
  let attribute = Attribute<V>((lhs as AnyKeyPath)._kvcKeyPathString!)
  return attribute << rhs
}
