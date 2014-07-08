//
//  QueryKitTests.swift
//  QueryKitTests
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import XCTest
import QueryKit

@objc(Person) class Person : NSManagedObject {
    @NSManaged var name:String
}

extension Person {
    class func create(context:NSManagedObjectContext) -> Person {
        return NSEntityDescription.insertNewObjectForEntityForName(Person.className(), inManagedObjectContext: context) as Person
    }
}

func managedObjectModel() -> NSManagedObjectModel {
    let personEntity = NSEntityDescription()
    personEntity.name = Person.className()
    personEntity.managedObjectClassName = Person.className()

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
