//
//  QueryKitTests.swift
//  QueryKitTests
//
//  Created by Kyle Fuller on 19/06/2014.
//
//

import XCTest
import QueryKit
import CoreData

@objc(Person) class Person : NSManagedObject {
    @NSManaged var name:String

    class var entityName:String {
        return "Person"
    }
}

extension Person {
    class func create(context:NSManagedObjectContext) -> Person {
        return NSEntityDescription.insertNewObjectForEntityForName(Person.entityName, inManagedObjectContext: context) as! Person
    }
}

func managedObjectModel() -> NSManagedObjectModel {
    let personEntity = NSEntityDescription()
    personEntity.name = Person.entityName
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
