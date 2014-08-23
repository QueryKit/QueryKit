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

@property (nonatomic, strong, readonly) NSString *name;

/// Initialized the attribute from multiple other attributes
- (instancetype)initWithAttributes:(QKAttribute *)attribute, ... NS_REQUIRES_NIL_TERMINATION;

/// Initialized the attribute with the given name
- (instancetype)initWithName:(NSString *)name __attribute((nonnull));

/** Returns a Boolean value that indicates whether a given attribute is equal to the receiver
 @param attribute The attribute to compare against the receiver
 @return YES if attribute is equivalent to the receiver
 */
- (BOOL)isEqualToAttribute:(QKAttribute *)attribute;

/** Returns an expression for the attributes key-value path */
- (NSExpression *)expression;

@end

@interface QKAttribute (Predicate)

/** Returns a predicate for an equality comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see equal:
 */
- (NSPredicate *)equal:(id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for an equality comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see equal:options:
 */
- (NSPredicate *)equal:(id)value;

/** Returns a predicate for an unequal comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see notEqual:
 */
- (NSPredicate *)notEqual:(id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for an unequal comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see notEqual:options:
 */
- (NSPredicate *)notEqual:(id)value;

/** Returns a predicate for a like comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see like:
 */
- (NSPredicate *)like:(id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a like comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see like:options:
 */
- (NSPredicate *)like:(id)value;

/** Returns a predicate for a matches comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see like:
 */
- (NSPredicate *)matches:(id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a matches comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see like:options:
 */
- (NSPredicate *)matches:(id)value;

/** Returns a predicate for a begins with comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see like:
 */
- (NSPredicate *)beginsWith:(id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a begins with comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see like:options:
 */
- (NSPredicate *)beginsWith:(id)value;

/** Returns a predicate for a ends with comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see like:
 */
- (NSPredicate *)endsWith:(id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a ends with comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see like:options:
 */
- (NSPredicate *)endsWith:(id)value;

/** Returns a predicate for greater than the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see greaterThanOrEqualTo:
 */
- (NSPredicate *)greaterThan:(id)value;

/** Returns a predicate for greater than or equal to the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see greaterThan:
 */
- (NSPredicate *)greaterThanOrEqualTo:(id)value;

/** Returns a predicate for less than the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see lessThanOrEqualTo:
 */
- (NSPredicate *)lessThan:(id)value;

/** Returns a predicate for less than or equal to the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see lessThan:
 */
- (NSPredicate *)lessThanOrEqualTo:(id)value;

/** Returns a predicate for attribute being between two values
 @param minimumValue
 @param maximumValue
 @return The predicate for this comparison
 */
- (NSPredicate *)between:(id)minimumValue and:(id)maxiumValue;

/** Returns an IN predicate for attribute
 @param set An enumerable object containing a set ob objects
 @return The predicate for this comparison
 */
- (NSPredicate *)in:(id<NSFastEnumeration>)set;

/** Returns a predicate for a contains with comparison against the supplied value
 @param value To compare against the attribute
 @param options NSComparisonPredicateOptions to apply to the comparison
 @return The predicate for this comparison
 @see contains:
 */
- (NSPredicate *)contains:(id)value options:(NSComparisonPredicateOptions)options;

/** Returns a predicate for a contains with comparison against the supplied value
 @param value To compare against the attribute
 @return The predicate for this comparison
 @see contains:options:
 */
- (NSPredicate *)contains:(id)value;

/** Returns a predicate for if the attribute being equal to nil
 @return The predicate for the attribute being nil.
 */
- (NSPredicate *)isNil;

/** Returns a predicate for if the attribute being equal to YES
 @return The predicate for the attribute being YES.
 @see isNO
 */
- (NSPredicate *)isYes;

/** Returns a predicate for if the attribute being equal to NO
 @return The predicate for the attribute being NO.
 @see isYes
 */
- (NSPredicate *)isNo;

@end

@interface QKAttribute (Sorting)

/** Returns an ascending sort descriptor for this attribute */
- (NSSortDescriptor *)ascending;

/** Returns a descending sort descriptor for this attribute */
- (NSSortDescriptor *)descending;

@end
