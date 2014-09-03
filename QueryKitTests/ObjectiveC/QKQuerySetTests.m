//
//  KFObjectManagerTests
//  KFDataTests
//
//  Created by Kyle Fuller on 14/06/2013.
//
//

#import <XCTest/XCTest.h>
#import <QueryKit/QueryKit.h>


@interface QKQuerySetTests : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSEntityDescription *entityDescription;
@property (nonatomic, strong) QKQuerySet *queryset;

@end

@implementation QKQuerySetTests

- (void)setUp {
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    self.entityDescription = [[NSEntityDescription alloc] init];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    NSArray *sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO]
    ];

    self.queryset = [[QKQuerySet alloc] initWithManagedObjectContext:self.managedObjectContext entityDescription:self.entityDescription predicate:predicate sortDescriptors:sortDescriptors range:NSMakeRange(1, 3)];
}

- (void)testInitializationWithContextAndEntityDescription {
    QKQuerySet *queryset = [[QKQuerySet alloc] initWithManagedObjectContext:self.managedObjectContext entityDescription:self.entityDescription];

    XCTAssertEqualObjects(queryset.managedObjectContext, self.managedObjectContext);
    XCTAssertEqualObjects(queryset.entityDescription, self.entityDescription);
    XCTAssertNil(queryset.predicate);
    XCTAssertEqualObjects(queryset.sortDescriptors, @[]);
}

- (void)testInitializationWithPredicateAndSortDescriptors {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    NSArray *sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO]
    ];

    XCTAssertEqualObjects(self.queryset.managedObjectContext, self.managedObjectContext);
    XCTAssertEqualObjects(self.queryset.entityDescription, self.entityDescription);
    XCTAssertEqualObjects(self.queryset.predicate, predicate);
    XCTAssertEqualObjects(self.queryset.sortDescriptors, sortDescriptors);
}

- (void)testCreationFromFetchRequest {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:self.entityDescription];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];

    QKQuerySet *queryset = [[QKQuerySet alloc] initWithManagedObjectContext:self.managedObjectContext fetchRequest:fetchRequest];

    XCTAssertEqualObjects(queryset.managedObjectContext, self.managedObjectContext);
    XCTAssertEqualObjects(queryset.entityDescription, self.entityDescription);
    XCTAssertEqualObjects(queryset.predicate, predicate);
    XCTAssertEqualObjects(queryset.sortDescriptors, sortDescriptors);
}

- (void)testIsEqual {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    NSArray *sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO]
    ];

    QKQuerySet *queryset = [[QKQuerySet alloc] initWithManagedObjectContext:self.managedObjectContext entityDescription:self.entityDescription predicate:predicate sortDescriptors:sortDescriptors range:NSMakeRange(1, 3)];

    XCTAssertEqualObjects(self.queryset, queryset);
    XCTAssertEqual([self.queryset hash], [queryset hash]);
}

- (void)testCopying {
    QKQuerySet *queryset = [self.queryset copy];
    XCTAssertEqualObjects(self.queryset, queryset);
}

- (void)testFilterAddsPredicate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age == 28"];
    QKQuerySet *filteredQuerySet = [self.queryset filter:predicate];

    XCTAssertEqualObjects(filteredQuerySet.predicate, [NSPredicate predicateWithFormat:@"name == 'Kyle' AND age == 28"]);
}

- (void)testExcludeAddsPredicate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age == 28"];
    QKQuerySet *queryset = [self.queryset exclude:predicate];

    XCTAssertEqualObjects(queryset.predicate, [NSPredicate predicateWithFormat:@"name == 'Kyle' AND (NOT age == 28)"]);
}

- (void)testOrderBy {
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    QKQuerySet *queryset = [self.queryset orderBy:sortDescriptors];

    XCTAssertEqualObjects(queryset.sortDescriptors, sortDescriptors);
}

- (void)testReverse {
    QKQuerySet *reversedQueryset = [self.queryset reverse];

    NSArray *reversedSortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO],
        [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES]
    ];

    XCTAssertEqualObjects(reversedQueryset.sortDescriptors, reversedSortDescriptors);
}

- (void)testFetchRequest {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'Kyle'"];
    NSArray *sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
        [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO]
    ];

    NSFetchRequest *fetchRequest = [self.queryset fetchRequest];

    XCTAssertEqualObjects(fetchRequest.entityName, self.entityDescription.name);
    XCTAssertEqualObjects(fetchRequest.predicate, predicate);
    XCTAssertEqualObjects(fetchRequest.sortDescriptors, sortDescriptors);
    XCTAssertEqual(fetchRequest.fetchOffset, 1);
    XCTAssertEqual(fetchRequest.fetchLimit, 3);
}

@end
