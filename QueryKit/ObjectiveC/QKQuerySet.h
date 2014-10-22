//
//  QKQuerySet.h
//  QueryKit
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 Represents a lazy Core Data lookup for a set of objects.

 This object is immutable, any changes will normally be done to a copy. Such
 as with the `-filter:`, `-exclude:`, `-orderBy:` and `-reverse` methods.
 */

@interface QKQuerySet : NSObject <NSFastEnumeration, NSCopying>

/// The managed object context for the query set
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/// The entity descriptor for the object
@property (nonatomic, strong, readonly) NSEntityDescription *entityDescription;

/** This is a read only property to hold any predicates set on this object. You can use the `filter:` and `exclude:` methods to effect this value on a child */
@property (nonatomic, copy, readonly) NSPredicate *predicate;

/** This is a read only property to hold any sort descriptors set on this object. You can use the `orderBy:` and `reverse` methods to effect this value on a child */
@property (nonatomic, copy, readonly) NSArray *sortDescriptors;

/** This is a read only property to hold a range set. */
@property (nonatomic, assign, readonly) NSRange range;

#pragma mark - Creation

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription __attribute((nonnull));
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext entityDescription:(NSEntityDescription *)entityDescription predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors range:(NSRange)range __attribute((nonnull(1, 2)));
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext fetchRequest:(NSFetchRequest *)fetchRequest __attribute((nonnull));

#pragma mark - Equality

/** Returns a Boolean value that indicates whether a given queryset is equal to the receiver
 @param queryset The queryset to compare against the receiver
 @return YES if queryset is equivalent to the receiver
 */
- (BOOL)isEqualToQuerySet:(QKQuerySet *)queryset;

#pragma mark -

/** Returns a fetch request for the queryset */
- (NSFetchRequest *)fetchRequest;

/** Returns the amount of objects matching the set predicate
 @param error If there is a problem fetching the count, upon return contains an instance of NSError that describes the problem.
 @return The number of objects matching the set predicate
 */
- (NSUInteger)count:(NSError **)error;

/** Returns all objects matching the set predicate ordered by any set sort descriptors as an array
 @param error If there is a problem fetching the objects, upon return contains an instance of NSError that describes the problem.
 @return An array containing all matched objects
 */
- (NSArray *)array:(NSError **)error;

/** Returns all objects matching the set predicate ordered by any set sort descriptors as an ordered set
 @param error If there is a problem fetching the objects, upon return contains an instance of NSError that describes the problem.
 @return An ordered set containing all matched objects
 */
- (NSSet *)set:(NSError **)error;

/** Returns all objects matching the set predicate ordered by any set sort descriptors as a set
 @param error If there is a problem fetching the objects, upon return contains an instance of NSError that describes the problem.
 @return A set containing all matched objects
 */
- (NSOrderedSet *)orderedSet:(NSError **)error;

#pragma mark - Enumeration

/** Enumerate all objects matching the set predicate ordered by any set sort descriptors
 @param block The block to apply to elements in the array
 @param error If there is a problem fetching the objects, upon return contains an instance of NSError that describes the problem.
 @return YES if the operation succeeded.
 */
- (BOOL)enumerateObjects:(void (^)(NSManagedObject *object, NSUInteger index, BOOL *stop))block error:(NSError **)error;

/** Enumerate all objects matching the set predicate ordered by any set sort descriptors
 @param block The block to apply to all objects
 @param error If there is a problem fetching the objects, upon return contains an instance of NSError that describes the problem.
 @return YES if the operation succeeded.
 */
- (BOOL)each:(void (^)(NSManagedObject *managedObject))block error:(NSError **)error;

#pragma mark - Deletion

/** Delete all objects matching the set predicate
 @param error If there is a problem deleting the objects, upon return contains an instance of NSError that describes the problem.
 @return Returns the amount of objects that were deleted
 */
- (NSUInteger)deleteObjects:(NSError **)error;

@end

/// Methods to sort an query set
@interface QKQuerySet (Sorting)

/** Returns a copy and the sort descriptors */
- (instancetype)orderBy:(NSArray *)sortDescriptors;

/** Returns a copy and reverses any sort descriptors */
- (instancetype)reverse;

@end

/// Filtering related methods of QKQuerySet
@interface QKQuerySet (Filtering)

/** Returns a copy filtered by a predicate */
- (instancetype)filter:(NSPredicate *)predicate;

/** Returns a copy excluding a predicate */
- (instancetype)exclude:(NSPredicate *)predicate;

@end

/// Fetching single objects in QKQuerySet
@interface QKQuerySet (SingleObject)

/** Returns a single object matching the filters, if there is more than one. An error will instead be returned.
 @param error If there is a problem fetching the object or there is more than one object, upon return contains an instance of NSError that describes the problem.
 @return Returns the object matching the set predicate, or nil.
 */
- (NSManagedObject *)object:(NSError **)error;

/** Returns the first object matching the filters ordered by the set sort descriptors.
 @param error If there is a problem fetching the object, upon return contains an instance of NSError that describes the problem.
 @return Returns the first object matching the set predicate, or nil.
 */
- (NSManagedObject *)firstObject:(NSError **)error;

/** Returns the last object matching the filters ordered by the set sort descriptors.
 @param error If there is a problem fetching the object, upon return contains an instance of NSError that describes the problem.
 @return Returns the last object matching the set predicate, or nil.
 */
- (NSManagedObject *)lastObject:(NSError **)error;

@end


@interface NSManagedObject (QKQuerySet)

+ (QKQuerySet *)querySetWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
