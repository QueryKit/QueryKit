//
//  QueryKitTests.swift
//  QueryKitTests
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import XCTest
import QueryKit

func managedObjectModel() -> NSManagedObjectModel {
    let personEntity = NSEntityDescription()
    personEntity.name = "Person"
    personEntity.managedObjectClassName = "Person"

    let personNameAttribute = NSAttributeDescription()
    personNameAttribute.name = "name"
    personNameAttribute.attributeType = NSAttributeType.StringAttributeType
    personNameAttribute.optional = false
    personEntity.properties = [personNameAttribute]

    let model = NSManagedObjectModel()
    model.entities = [personEntity]

    return model
}

func persistentStoreCoordinator() -> NSPersistentStoreCoordinator {
    let model = managedObjectModel()
    let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: nil)
    return persistentStoreCoordinator
}

class Person : NSManagedObject {
    class func create(context:NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObjectForEntityForName("Person", inManagedObjectContext: context) as NSManagedObject
    }
}

class QueryKitTests: XCTestCase {
    var context:NSManagedObjectContext?
    var queryset:QuerySet?

    override func setUp() {
        super.setUp()

        context = NSManagedObjectContext()
        context!.persistentStoreCoordinator = persistentStoreCoordinator()

        var kyle = Person.create(context!)
        kyle.setValue("Kyle", forKey: "name")
        var orta = Person.create(context!)
        orta.setValue("Orta", forKey: "name")
        var ayaka = Person.create(context!)
        ayaka.setValue("Ayaka", forKey: "name")
        var mark = Person.create(context!)
        mark.setValue("Mark", forKey: "name")
        var scott = Person.create(context!)
        scott.setValue("Scott", forKey: "name")
        context!.save(nil)

        queryset = QuerySet(context!, "Person")
    }

    // Sorting

    func testOrderBySortDescriptor() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var qs = queryset!.orderBy(sortDescriptor)
        XCTAssertEqualObjects(qs.sortDescriptors, [sortDescriptor])
    }

    func testOrderBySortDescriptors() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        var qs = queryset!.orderBy([sortDescriptor])
        XCTAssertEqualObjects(qs.sortDescriptors, [sortDescriptor])
    }

    // Filtering

    func testFilterPredicate() {
        let predicate = NSPredicate(format: "name == Kyle")
        var qs = queryset!.filter(predicate)
        XCTAssertEqualObjects(qs.predicate, predicate)
    }

    func testFilterPredicates() {
        let predicateName = NSPredicate(format: "name == Kyle")
        let predicateAge = NSPredicate(format: "age > 27")

        var qs = queryset!.filter([predicateName, predicateAge])
        XCTAssertEqualObjects(qs.predicate, NSPredicate(format: "name == Kyle AND age > 27"))
    }

    // Exclusion

    func testExcludePredicate() {
        let predicate = NSPredicate(format: "name == Kyle")
        var qs = queryset!.exclude(predicate)
        XCTAssertEqualObjects(qs.predicate, NSPredicate(format: "NOT name == Kyle"))
    }

    func testExcludePredicates() {
        let predicateName = NSPredicate(format: "name == Kyle")
        let predicateAge = NSPredicate(format: "age > 27")

        var qs = queryset!.exclude([predicateName, predicateAge])
        XCTAssertEqualObjects(qs.predicate, NSPredicate(format: "NOT (name == Kyle AND age > 27)"))
    }

    // Fetch Request

    func testConversionToFetchRequest() {
        let predicate = NSPredicate(format: "name == Kyle")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let qs = queryset!.filter(predicate).orderBy(sortDescriptor)[2..4]

        let fetchRequest:NSFetchRequest = NSFetchRequest(qs)

        XCTAssertEqualObjects(fetchRequest.entityName, "Person")
        XCTAssertEqualObjects(fetchRequest.predicate, predicate)
        XCTAssertEqualObjects(fetchRequest.sortDescriptors, [sortDescriptor])
        XCTAssertEqual(fetchRequest.fetchOffset, 2)
        XCTAssertEqual(fetchRequest.fetchLimit, 2)
    }

    // Subscripting

    func testSubscriptingAtIndex() {
        var qs = queryset!.orderBy(NSSortDescriptor(key: "name", ascending: true))

        var ayaka = qs[0].object
        var kyle = qs[1].object
        var mark = qs[2].object
        var orta:NSManagedObject? = qs[3].object
        var scott:NSManagedObject? = qs[4]

        XCTAssertEqualObjects(ayaka!.valueForKey("name") as String, "Ayaka")
        XCTAssertEqualObjects(kyle!.valueForKey("name") as String, "Kyle")
        XCTAssertEqualObjects(mark!.valueForKey("name") as String, "Mark")
        XCTAssertEqualObjects(orta!.valueForKey("name") as String, "Orta")
        XCTAssertEqualObjects(scott!.valueForKey("name") as String, "Scott")
    }

    func testSubscriptingRange() {
        var qs = queryset!.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...2]

        XCTAssertEqualObjects(qs.range!.startIndex, 0)
        XCTAssertEqualObjects(qs.range!.endIndex, 3)
    }

    func testSubscriptingRangeSubscriptsCurrentRange() {
        var qs = queryset!.orderBy(NSSortDescriptor(key: "name", ascending: true))
        qs = qs[2...5]
        qs = qs[2...4]

        XCTAssertEqualObjects(qs.range!.startIndex, 4)
        XCTAssertEqualObjects(qs.range!.endIndex, 5)
    }

    // Conversion

    func testConversionToArray() {
        var qs = queryset!.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var people = qs.array().objects

        XCTAssertEqual(people!.count, 2)
    }

    func testConversionToArrayWithoutError() {
        var qs = queryset!.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var people = qs.array() as? NSManagedObject[]

        XCTAssertEqual(people!.count, 2)
    }

    // Count

    func testCount() {
        var qs = queryset!.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var count = qs.count().count

        XCTAssertEqual(count, 2)
    }

    func testCountWithoutError() {
        var qs = queryset!.orderBy(NSSortDescriptor(key: "name", ascending: true))[0...1]
        var count = qs.count() as Int

        XCTAssertEqual(count, 2)
    }
}
