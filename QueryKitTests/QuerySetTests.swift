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

    // Sorting

    func testOrderBySortDescriptor() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var qs = queryset.orderBy(sortDescriptor)
        XCTAssertEqualObjects(qs.sortDescriptors, [sortDescriptor])
    }

    func testOrderBySortDescriptors() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var qs = queryset.orderBy([sortDescriptor])
        XCTAssertEqualObjects(qs.sortDescriptors, [sortDescriptor])
    }

    // Filtering

    func testFilterPredicate() {
        let predicate = NSPredicate(format: "name == Kyle")
        var qs = queryset.filter(predicate)
        XCTAssertEqualObjects(qs.predicate, predicate)
    }

    func testFilterPredicates() {
        let predicateName = NSPredicate(format: "name == Kyle")
        let predicateAge = NSPredicate(format: "age > 27")

        var qs = queryset.filter([predicateName, predicateAge])
        XCTAssertEqualObjects(qs.predicate, NSPredicate(format: "name == Kyle AND age > 27"))
    }

    // Exclusion

    func testExcludePredicate() {
        let predicate = NSPredicate(format: "name == Kyle")
        var qs = queryset.exclude(predicate)
        XCTAssertEqualObjects(qs.predicate, NSPredicate(format: "NOT name == Kyle"))
    }

    func testExcludePredicates() {
        let predicateName = NSPredicate(format: "name == Kyle")
        let predicateAge = NSPredicate(format: "age > 27")

        var qs = queryset.exclude([predicateName, predicateAge])
        XCTAssertEqualObjects(qs.predicate, NSPredicate(format: "NOT (name == Kyle AND age > 27)"))
    }

    // Boolean attribute filtering and exclusion

    func testFilterBooleanAttribute() {
        let qs = queryset.filter(Attribute<Bool>("isEmployed"))
        XCTAssertEqualObjects(qs.predicate, NSPredicate(format: "isEmployed == YES"))
    }

    func testExcludeBooleanAttribute() {
        let qs = queryset.exclude(Attribute<Bool>("isEmployed"))
        XCTAssertEqualObjects(qs.predicate, NSPredicate(format: "isEmployed == NO"))
    }

    // Fetch Request

    func testConversionToFetchRequest() {
        let predicate = NSPredicate(format: "name == Kyle")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let qs = queryset.filter(predicate).orderBy(sortDescriptor)[2..<4]

        let fetchRequest = qs.fetchRequest

        XCTAssertEqualObjects(fetchRequest.entityName, Person.className())
        XCTAssertEqualObjects(fetchRequest.predicate, predicate)
        XCTAssertEqualObjects(fetchRequest.sortDescriptors, [sortDescriptor])
        XCTAssertEqual(fetchRequest.fetchOffset, 2)
        XCTAssertEqual(fetchRequest.fetchLimit, 2)
    }

    // Subscripting

    func testSubscriptingAtIndex() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))

        var ayaka = qs[0].object
        var kyle = qs[1].object
        var mark = qs[2].object
        var orta:Person? = qs[3].object
        var scott:Person? = qs[4]

        XCTAssertEqualObjects(ayaka!.name, "Ayaka")
        XCTAssertEqualObjects(kyle!.name, "Kyle")
        XCTAssertEqualObjects(mark!.name, "Mark")
        XCTAssertEqualObjects(orta!.name, "Orta")
        XCTAssertEqualObjects(scott!.name, "Scott")
    }

    func testSubscriptingRange() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...2]

        XCTAssertEqualObjects(qs.range!.startIndex, 0)
        XCTAssertEqualObjects(qs.range!.endIndex, 3)
    }

    func testSubscriptingRangeSubscriptsCurrentRange() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))
        qs = qs[2...5]
        qs = qs[2...4]

        XCTAssertEqualObjects(qs.range!.startIndex, 4)
        XCTAssertEqualObjects(qs.range!.endIndex, 5)
    }

    // Conversion

    func testConversionToArray() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var people = qs.array().objects

        XCTAssertEqual(people!.count, 2)
    }

    func testConversionToArrayWithoutError() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var people = qs.array() as? [Person]

        XCTAssertEqual(people!.count, 2)
    }

    // Count

    func testCount() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var count = qs.count().count

        XCTAssertEqual(count, 2)
    }

    func testCountWithoutError() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var count = qs.count() as Int

        XCTAssertEqual(count, 2)
    }

    // Deletion

    func testDelete() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))

        var deletedCount = qs[0...1].delete().count
        var count = qs.count() as Int

        XCTAssertEqual(deletedCount, 2)
        XCTAssertEqual(count, 3)
    }

    // Sequence

    func testSequence() {
        var qs = queryset.orderBy(NSSortDescriptor(key: "name", ascending: true))
        var objects = [Person]()
        
        for object in qs {
            objects.append(object)
        }
        
        XCTAssertEqual(objects.count, 5)
    }
}
