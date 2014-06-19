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

class Person : NSManagedObject { }

class QueryKitTests: XCTestCase {
    var context:NSManagedObjectContext?
    var queryset:QuerySet?

    override func setUp() {
        super.setUp()

        context = NSManagedObjectContext()
        context!.persistentStoreCoordinator = persistentStoreCoordinator()

        queryset = QuerySet(context!, "Person")
    }
}
