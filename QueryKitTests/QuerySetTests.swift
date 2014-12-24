//
//  QuerySetTests.swift
//  QueryKit
//
//  Created by Kyle Fuller on 06/07/2014.
//
//

import XCTest
import QueryKit

class QuerySetTests: XCTestCase {
    var context:NSManagedObjectContext!
    var queryset:QuerySet<Person>!

    override func setUp() {
        super.setUp()

        context = NSManagedObjectContext()
        context.persistentStoreCoordinator = persistentStoreCoordinator()

        for name in ["Kyle", "Orta", "Ayaka", "Mark", "Scott"] {
            let person = Person.create(context)
            person.name = name
        }

        context.save(nil)

        queryset = QuerySet(context, "Person")
    }

    func testEqualQuerySetIsEquatable() {
        XCTAssertEqual(queryset, QuerySet(context, "Person"))
    }

    // MARK: Sorting

    func testOrderBySortDescriptor() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var qs = queryset.orderBy(sortDescriptor)
        XCTAssertTrue(qs.sortDescriptors == [sortDescriptor])
    }

    func testOrderBySortDescriptors() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var qs = queryset.orderBy([sortDescriptor])
        XCTAssertTrue(qs.sortDescriptors == [sortDescriptor])
    }

    func testReverseOrdering() {
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let ageSortDescriptor = NSSortDescriptor(key: "age", ascending: true)
        let qs = queryset.orderBy([nameSortDescriptor, ageSortDescriptor]).reverse()

        XCTAssertEqual(qs.sortDescriptors, [ageSortDescriptor, nameSortDescriptor])
    }

    // MARK: Filtering

    func testFilterPredicate() {
        let predicate = NSPredicate(format: "name == Kyle")!
        var qs = queryset.filter(predicate)
        XCTAssertEqual(qs.predicate!, predicate)
    }

    func testFilterPredicates() {
        let predicateName = NSPredicate(format: "name == Kyle")!
        let predicateAge = NSPredicate(format: "age > 27")!

        var qs = queryset.filter([predicateName, predicateAge])
        XCTAssertEqual(qs.predicate!, NSPredicate(format: "name == Kyle AND age > 27")!)
    }

    func testFilterBooleanAttribute() {
        let qs = queryset.filter(Attribute<Bool>("isEmployed"))
        XCTAssertEqual(qs.predicate!, NSPredicate(format: "isEmployed == YES")!)
    }

    // MARK: Exclusion

    func testExcludePredicate() {
        let predicate = NSPredicate(format: "name == Kyle")!
        var qs = queryset.exclude(predicate)
        XCTAssertEqual(qs.predicate!, NSPredicate(format: "NOT name == Kyle")!)
    }

    func testExcludePredicates() {
        let predicateName = NSPredicate(format: "name == Kyle")!
        let predicateAge = NSPredicate(format: "age > 27")!

        var qs = queryset.exclude([predicateName, predicateAge])
        XCTAssertEqual(qs.predicate!, NSPredicate(format: "NOT (name == Kyle AND age > 27)")!)
    }

    func testExcludeBooleanAttribute() {
        let qs = queryset.exclude(Attribute<Bool>("isEmployed"))
        XCTAssertEqual(qs.predicate!, NSPredicate(format: "isEmployed == NO")!)
    }

    // Fetch Request

    func testConversionToFetchRequest() {
        let predicate = NSPredicate(format: "name == Kyle")!
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let qs = queryset.filter(predicate).orderBy(sortDescriptor)[2..<4]

        let fetchRequest = qs.fetchRequest

        XCTAssertEqual(fetchRequest.entityName!, "Person")
        XCTAssertEqual(fetchRequest.predicate!, predicate)
//        XCTAssertEqual(fetchRequest.sortDescriptors!, [sortDescriptor])
        XCTAssertEqual(fetchRequest.fetchOffset, 2)
        XCTAssertEqual(fetchRequest.fetchLimit, 2)
    }

    // MARK: Subscripting

    func testSubscriptingAtIndex() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))

        var ayaka = qs[0].object
        var kyle = qs[1].object
        var mark = qs[2].object
        var orta:Person? = qs[3].object
        var scott:Person? = qs[4]

        XCTAssertEqual(ayaka!.name, "Ayaka")
        XCTAssertEqual(kyle!.name, "Kyle")
        XCTAssertEqual(mark!.name, "Mark")
        XCTAssertEqual(orta!.name, "Orta")
        XCTAssertEqual(scott!.name, "Scott")
    }

    func testSubscriptingRange() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...2]

        XCTAssertEqual(qs.range!.startIndex, 0)
        XCTAssertEqual(qs.range!.endIndex, 3)
    }

    func testSubscriptingRangeSubscriptsCurrentRange() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))
        qs = qs[2...5]
        qs = qs[2...4]

        XCTAssertEqual(qs.range!.startIndex, 4)
        XCTAssertEqual(qs.range!.endIndex, 5)
    }

    // MARK: Conversion

    func testConversionToArray() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var people = qs.array().objects

        XCTAssertEqual(people!.count, 2)
    }

    func testConversionToArrayWithoutError() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var people = qs.array() as [Person]?

        XCTAssertEqual(people!.count, 2)
    }

    // MARK: Count

    func testCount() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var count = qs.count().count

        XCTAssertEqual(count!, 2)
    }

    func testCountWithoutError() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var count = qs.count() as Int?

        XCTAssertEqual(count!, 2)
    }

    // MARK: Exists

    func testExistsReturnsTrueWithMatchingObjects()  {
        let qs = queryset.filter(NSPredicate(format: "name == %@", "Kyle")!)
        XCTAssertTrue(qs.exists()!)
    }

    func testExistsReturnsFalseWithNoMatchingObjects()  {
        let qs = queryset.filter(NSPredicate(format: "name == %@", "None")!)
        XCTAssertFalse(qs.exists()!)
    }

    // MARK: Deletion

    func testDelete() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))

        var deletedCount = qs[0...1].delete().count
        var count = qs.count() as Int?

        XCTAssertEqual(deletedCount, 2)
        XCTAssertEqual(count!, 3)
    }

    // MARK: Sequence

    func testSequence() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))
        var objects = [Person]()
        
        for object in qs {
            objects.append(object)
        }
        
        XCTAssertEqual(objects.count, 5)
    }
}
