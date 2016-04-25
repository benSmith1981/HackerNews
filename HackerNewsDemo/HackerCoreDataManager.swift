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
    static let entityName = "HackerNewsModel"

    // MARK: Songs API methods
    
    //Get all Articles stored from coreDataModel
    class func getAllArticles() throws -> [HackerManagedObject] {
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        
        // Fetch reqest for entity Person
        let fetchRequest = NSFetchRequest(entityName: entityName)
        // Adding the predicate
        let predicate = NSPredicate(format: "userDeletedArticle == false")
        fetchRequest.predicate = predicate
        
        // Getting the result and return an error or the names as ManagedObjects
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            return results as! [HackerManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            throw error
        }
    }
    
    //Get all articles older than two days
    class func getAll2DayOldArticles() throws -> [HackerManagedObject] {
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        
        // Fetch reqest for entity Person
        let fetchRequest = NSFetchRequest(entityName: entityName)
        // Adding the predicate
        // 172800= 2 days in seconds, so articles less than this are two days old, then we purge
        let predicate = NSPredicate(format: "createdTimeSeconds < %@" , "\(Int64(NSDate().timeIntervalSince1970 - Double(HackerNewsConstants.timeInSeconds.twoDaysInSeconds)))")
        fetchRequest.predicate = predicate

        // Getting the result and return an error or the names as ManagedObjects
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
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
            
            //Create a hacker news article managed object
            let hackerNewsArticle: HackerManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedContext) as! HackerManagedObject
            //Clone article into managed object
            hackerNewsArticle.cloneFromHackerNewsModel(article)
            // Save
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
    
    //Delete an article from the core data store
    class func setArticleToDeleted(article: HackerManagedObject) throws -> Bool {
        article.userDeletedArticle = true
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
    
    //Delete all articles older than two days
    class func purgeTwoDayOldArticles() {
        
        if let articles = try? HackerCoreDataManager.getAll2DayOldArticles() {
            for article in articles {
                print(NSDate().hoursFrom(article.createdTimeStampDate))
                let _ = try? HackerCoreDataManager.deleteArticle(article)
            }
        }
    }

    //Delete an article from the core data store
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
     Check if the Article is already saved in local database
     
     - parameter trackId: trackId for the song witch need to be verified
     
     - returns: if the Article is stored returns true, else - false
     */
    
    class func checkIfArticleAlreadyIsStored(storyID: Int) -> Bool {
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
