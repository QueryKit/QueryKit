//
//  QKAttribute.h
//  QueryKit
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import <Foundation/Foundation.h>

/** A helper class to generate predicates and sort descriptors for attributes
 on a managed object.
 */
@interface QKAttribute : NSObject <NSSecureCoding, NSCopying>

/// The name for the attribute.
@property (nonatomic, strong, readonly, nonnull) NSString *name;

/// Initialized the attribute from multiple other attributes
- (nonnull instancetype)initWithAttributes:(nonnull QKAttribute *)attribute, ... NS_REQUIRES_NIL_TERMINATION;

/// Initialized the attribute with the given name
- (nonnull instancetype)initWithName:(nonnull NSString *)name;

/** Returns a Boolean value that indicates whether a given attribute is equal to the receiver
 @param attribute The attribute to compare against the receiver
 @return YES if attribute is equivalent to the receiver
 */
- (BOOL)isEqualToAttribute:(nonnull QKAttribute *)attribute;

/** Returns an expression for the attributes key-value path */
- (nonnull NSExpression *)expression;

@end

/// Predicates
@interface QKAttribute (Predicate)

/** Returns a predicate for an equality comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see equal:
 */
- (nonnull NSPredicate *)equal:(nullable id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for an equality comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see equal:options:
 */
- (nonnull NSPredicate *)equal:(nullable id)value;

/** Returns a predicate for an unequal comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see notEqual:
 */
- (nonnull NSPredicate *)notEqual:(nullable id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for an unequal comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see notEqual:options:
 */
- (nonnull NSPredicate *)notEqual:(nullable id)value;

/** Returns a predicate for a like comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see like:
 */
- (nonnull NSPredicate *)like:(nonnull id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a like comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see like:options:
 */
- (nonnull NSPredicate *)like:(nonnull id)value;

/** Returns a predicate for a matches comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see like:
 */
- (nonnull NSPredicate *)matches:(nonnull id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a matches comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see like:options:
 */
- (nonnull NSPredicate *)matches:(nonnull id)value;

/** Returns a predicate for a begins with comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see like:
 */
- (nonnull NSPredicate *)beginsWith:(nonnull id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a begins with comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see like:options:
 */
- (nonnull NSPredicate *)beginsWith:(nonnull id)value;

/** Returns a predicate for a ends with comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see like:
 */
- (nonnull NSPredicate *)endsWith:(nonnull id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a ends with comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see like:options:
 */
- (nonnull NSPredicate *)endsWith:(nonnull id)value;

/** Returns a predicate for greater than the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see greaterThanOrEqualTo:
 */
- (nonnull NSPredicate *)greaterThan:(nonnull id)value;

/** Returns a predicate for greater than or equal to the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see greaterThan:
 */
- (nonnull NSPredicate *)greaterThanOrEqualTo:(nonnull id)value;

/** Returns a predicate for less than the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see lessThanOrEqualTo:
 */
- (nonnull NSPredicate *)lessThan:(nonnull id)value;

/** Returns a predicate for less than or equal to the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see lessThan:
 */
- (nonnull NSPredicate *)lessThanOrEqualTo:(nonnull id)value;

/** Returns a predicate for attribute being between two values
 @param minimumValue
 @param maximumValue
 @return The predicate for this comparison
 */
- (nonnull NSPredicate *)between:(nonnull id)minimumValue and:(nonnull id)maxiumValue;

/** Returns an IN predicate for attribute
 @param set An enumerable object containing a set ob objects
 @return The predicate for this comparison
 */
- (nonnull NSPredicate *)in:(nonnull id<NSFastEnumeration>)set;

/** Returns a predicate for a contains with comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see contains:
 */
- (nonnull NSPredicate *)contains:(nonnull id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a contains with comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see contains:options:
 */
- (nonnull NSPredicate *)contains:(nonnull id)value;

/** Returns a predicate for if the attribute being equal to nil
 @return The predicate for the attribute being nil.
 */
- (nonnull NSPredicate *)isNil;

/** Returns a predicate for if the attribute being equal to YES
 @return The predicate for the attribute being YES.
 @see isNO
 */
- (nonnull NSPredicate *)isYes;

/** Returns a predicate for if the attribute being equal to NO
 @return The predicate for the attribute being NO.
 @see isYes
 */
- (nonnull NSPredicate *)isNo;

@end

/// Sorting
@interface QKAttribute (Sorting)

/** Returns an ascending sort descriptor for this attribute */
- (nonnull NSSortDescriptor *)ascending;

/** Returns a descending sort descriptor for this attribute */
- (nonnull NSSortDescriptor *)descending;

@end
