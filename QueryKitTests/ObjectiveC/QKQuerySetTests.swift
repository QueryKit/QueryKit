//
//  QuerySetTests.swift
//  QueryKit
//
//  Created by Kyle Fuller on 06/07/2014.
//
//

import XCTest
import QueryKit

class QKQuerySetConversionTests: XCTestCase {
  var qkQueryset:QKQuerySet!
  var queryset:QuerySet<NSManagedObject>!

  override func setUp() {
    super.setUp()

    let context = NSManagedObjectContext()
    context.persistentStoreCoordinator = persistentStoreCoordinator()
    let entityDescription = NSEntityDescription.entityForName("Person", inManagedObjectContext:context)!
    let predicate = NSPredicate(format: "name == 'Kyle'")
    let sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

    qkQueryset = QKQuerySet(managedObjectContext: context, entityDescription: entityDescription, predicate: predicate, sortDescriptors: sortDescriptors, range:NSMakeRange(1, 4))
    queryset = QuerySet<NSManagedObject>(context, "Person")
    queryset = queryset.filter(predicate).orderBy(sortDescriptors)[1..<5]
  }

  func testConvertingQuerySetToQKQuerySet() {
    XCTAssertEqual(queryset.asQKQuerySet(), qkQueryset)
  }

  func testConvertingQKQuerySetToQuerySet() {
    XCTAssertEqual(qkQueryset.asQuerySet(), queryset)
  }
}
