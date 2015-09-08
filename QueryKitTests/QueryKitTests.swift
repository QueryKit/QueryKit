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

  class var name:Attribute<String> {
    return Attribute("name")
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
  do {
    try persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
  } catch _ {
  }
  return persistentStoreCoordinator
}

public func AssertNotThrow<R>(@autoclosure closure: () throws -> R) -> R? {
  var result: R?
  AssertNotThrow() {
    result = try closure()
  }
  return result
}

public func AssertNotThrow(@noescape closure: () throws -> ()) {
  do {
    try closure()
  } catch let error {
    XCTFail("Catched error \(error), "
      + "but did not expect any error.")
  }
}
