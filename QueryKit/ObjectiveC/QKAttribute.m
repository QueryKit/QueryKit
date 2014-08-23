//
//  QKAttribute.m
//  QueryKit
//
//  Created by Kyle Fuller on 30/04/2013.
//
//

#import "QKAttribute.h"

@implementation QKAttribute

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    NSString *name = [decoder decodeObjectOfClass:[NSString class] forKey:@"name"];
    return [self initWithName:name];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    NSString *name = [self.name copyWithZone:zone];
    return [[[self class] alloc] initWithName:name];
}

#pragma mark -

- (instancetype)initWithAttributes:(QKAttribute *)attribute, ... {
    NSParameterAssert(attribute != nil);

    NSMutableArray *attributes = [NSMutableArray arrayWithObject:attribute.name];

    va_list attributeList;
    va_start(attributeList, attribute);
    while ((attribute = va_arg(attributeList, id))) {
        [attributes addObject:attribute.name];
    }
    va_end(attributeList);

    NSString *name = [attributes componentsJoinedByString:@"."];

    if (self = [super init]) {
        _name = name;
    }

    return self;
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
    }

    return self;
}

- (NSExpression *)expression {
    return [NSExpression expressionForKeyPath:self.name];
}

#pragma mark - Equality

- (NSUInteger)hash {
    return [self.name hash];
}

- (BOOL)isEqualToAttribute:(QKAttribute *)attribute {
    return [self.name isEqualToString:attribute.name];
}

- (BOOL)isEqual:(id)object {
    return object == self || ([object isKindOfClass:[QKAttribute class]] && [self isEqualToAttribute:object]);
}

#pragma mark -

// The following methods are implemented so that `[NSPredicate predicateWithFormat:@"%K", attribute]` will work

- (NSString *)description {
    return self.name;
}

- (NSRange)rangeOfString:(NSString *)aString {
    return [self.name rangeOfString:aString];
}

- (NSArray *)componentsSeparatedByString:(NSString *)separator {
    return [self.name componentsSeparatedByString:separator];
}

- (NSUInteger)length {
    return [self.name length];
}

#pragma mark - Comparison

- (NSPredicate *)predicateWithRightExpression:(NSExpression *)expression
                                     modifier:(NSComparisonPredicateModifier)modifier
                                         type:(NSPredicateOperatorType)type
                                      options:(NSComparisonPredicateOptions)options
{
    NSExpression *leftExpression = [self expression];

    return [NSComparisonPredicate predicateWithLeftExpression:leftExpression
                                              rightExpression:expression
                                                     modifier:modifier
                                                         type:type
                                                      options:options];
}

@end

@implementation QKAttribute (Predicate)

- (NSPredicate *)equal:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)equal:(id)value {
    return [self equal:value options:0];
}

- (NSPredicate *)notEqual:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSNotEqualToPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)notEqual:(id)value {
    return [self notEqual:value options:0];
}

- (NSPredicate *)beginsWith:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSBeginsWithPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)beginsWith:(id)value {
    return [self beginsWith:value options:0];
}

- (NSPredicate *)endsWith:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEndsWithPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)endsWith:(id)value {
    return [self endsWith:value options:0];
}

- (NSPredicate *)like:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSLikePredicateOperatorType
                                      options:options];
}

- (NSPredicate *)like:(id)value {
    return [self like:value options:0];
}

- (NSPredicate *)matches:(id)value options:(NSComparisonPredicateOptions)options {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSMatchesPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)matches:(id)value {
    return [self matches:value options:0];
}

- (NSPredicate *)greaterThan:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSGreaterThanPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)greaterThanOrEqualTo:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSGreaterThanOrEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)lessThan:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSLessThanPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)lessThanOrEqualTo:(id)value {
    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSLessThanOrEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)isNil {
    NSExpression *expression = [NSExpression expressionForConstantValue:nil];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)between:(id)minimumValue and:(id)maxiumValue {
    NSParameterAssert(minimumValue != nil);
    NSParameterAssert(maxiumValue != nil);

    NSExpression *expression = [NSExpression expressionForConstantValue:@[minimumValue, maxiumValue]];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSBetweenPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)in:(id<NSFastEnumeration>)set {
    NSParameterAssert(set != nil);

    NSExpression *expression = [NSExpression expressionForConstantValue:set];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSInPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)contains:(id)value options:(NSComparisonPredicateOptions)options {
    NSParameterAssert(value != nil);

    NSExpression *expression = [NSExpression expressionForConstantValue:value];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSContainsPredicateOperatorType
                                      options:options];
}

- (NSPredicate *)contains:(id)value {
    return [self contains:value options:0];
}

- (NSPredicate *)isYes {
    NSExpression *expression = [NSExpression expressionForConstantValue:@YES];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:0];
}

- (NSPredicate *)isNo {
    NSExpression *expression = [NSExpression expressionForConstantValue:@NO];

    return [self predicateWithRightExpression:expression
                                     modifier:NSDirectPredicateModifier
                                         type:NSEqualToPredicateOperatorType
                                      options:0];
}

@end

@implementation QKAttribute (Sorting)

- (NSSortDescriptor *)ascending {
    return [[NSSortDescriptor alloc] initWithKey:self.name ascending:YES];
}

- (NSSortDescriptor *)descending {
    return [[NSSortDescriptor alloc] initWithKey:self.name ascending:NO];
}

@end
