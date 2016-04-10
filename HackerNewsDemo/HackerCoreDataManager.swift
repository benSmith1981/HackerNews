//
//  Entity.swift
//  HackerNewsDemo
//
//  Created by Ben Smith on 10/04/16.
//  Copyright © 2016 Ben Smith. All rights reserved.
//

import Foundation
import CoreData


class HackerCoreDataManager {

// Insert code here to add functionality to your managed object subclass
    class func sharedStore() -> HackerCoreDataManager
    {
        struct Static {
            static var instance: HackerCoreDataManager?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token, {
            Static.instance = HackerCoreDataManager()
        })
        return Static.instance!
    }
    
    let managedObjectContext: NSManagedObjectContext =
        {
            let moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
            moc.undoManager = nil
            moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            return moc
    }()
    
    let managedObjectModel: NSManagedObjectModel =
        {
            let url = NSBundle.mainBundle().URLForResource("HackerDataModel", withExtension: "momd")
            let mom = NSManagedObjectModel(contentsOfURL: url!)
            
            return mom!
    }()
    
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    init()
    {
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let urls = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        let docUrl: NSURL = urls[urls.count - 1] as NSURL
        let url = docUrl.URLByAppendingPathComponent("Todo.sqlite")
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
//        let error: NSErrorPointer = nil
        
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        } catch{}
        
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
    func createNewItemWithName(name: String?) -> HackerNewsModel
    {
        let obj = NSEntityDescription.insertNewObjectForEntityForName("HackerDataModel", inManagedObjectContext: managedObjectContext) as! HackerNewsModel
        
//        if (name != nil) {
//            obj.
//            obj.name = name!
//        }
        
        return obj
    }
    
    func save() {
        let moc = managedObjectContext
        
        moc.performBlockAndWait {
            let error: NSErrorPointer = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error.memory = error1
                    print("\(error)")
                } catch {
                    fatalError()
                }
            }
        }
    }
    
    func objectWithID(objectID: NSManagedObjectID) -> NSManagedObject {
        return managedObjectContext.objectWithID(objectID)
    }
    
    func deleteObject(object: NSManagedObject) {
        let moc = managedObjectContext
        moc.performBlockAndWait {
            moc.deleteObject(object)
        }
    }
    
    deinit {
        save()
    }
}
