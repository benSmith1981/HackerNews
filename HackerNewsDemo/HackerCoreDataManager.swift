//
//  HackerCoreDataManager.swift
//  HackerNewsDemo
//
//  Created by Ben Smith on 10/04/16.
//  Copyright © 2016 Ben Smith. All rights reserved.
//

import Foundation
import CoreData


class HackerCoreDataManager {
    static let entityName = "HackerNews"
    
    // MARK: Songs API methods
    
    //Get all songs stored from coreDataModel
    class func getAllArticles() throws -> [HackerManagedObject] {
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        
        // Fetch reqest for entity Person
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        // Getting the result and return an error or the names as ManagedObjects
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            return results as! [HackerManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            throw error
        }
    }
    
    //Save the new Article and return a managedObject
    class func saveNewArticle(article: HackerNewsArticle?) throws -> HackerManagedObject? {
        
        if let article = article {
            let managedContext = CoreDataManager.sharedInstance.managedObjectContext
            
            // Get the object to insert for CDSong entitiy and given managedObjectContex
            let hackerNewsArticle: HackerManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! HackerManagedObject
            
            hackerNewsArticle.cloneFromHackerNewsModel(articleObject: article)
            // Save the new person
            do {
                try managedContext.save()
                return hackerNewsArticle
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
                throw error
            }
        }
        return nil
    }
    
    //Detele a song from the core data store
    class func deleteArticle(article: HackerManagedObject) throws -> Bool {
        CoreDataManager.sharedInstance.managedObjectContext.deleteObject(article)
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        // delete the article
        do {
            try managedContext.save()
            return true
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            return false
        }
    }
    
    /**
     Check if the song is already saved in local database
     
     - parameter trackId: trackId for the song witch need to be verified
     
     - returns: if the song is stored returns true, else - false
     */
    
    class func  checkIfArticleAlreadyIsStored(storyID: Int) -> Bool {
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        
        // Fetch reqest for entity Person
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        // Adding the predicate
        let predicate = NSPredicate(format: "storyID == %@", "\(storyID)")
        fetchRequest.predicate = predicate
        
        // Getting the result and return an error or the names as ManagedObjects
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [HackerManagedObject]
            return ( results.count > 0 ) ? true : false
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }

}
