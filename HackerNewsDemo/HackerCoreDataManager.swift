//
//  HackerCoreDataManager.swift
//  HackerNewsDemo
//
//  Created by Ben Smith on 10/04/16.
//  Copyright © 2016 Ben Smith. All rights reserved.
//
//  This class provides helper methods to access coredata
//

import Foundation
import CoreData


class HackerCoreDataManager {
    
    /**
     Get all Articles that have not been marked as deleted that are stored in our coreDataModel
     
     - returns: Return the managed object array of all articles that the user has not deleted
     */
    class func getAllArticles() throws -> [HackerManagedObject] {
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        
        // Fetch reqest for entity Person
        let fetchRequest = NSFetchRequest(entityName: HackerNewsConstants.coreDataEntities.HackerNewsModel)
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
    
    
    /**
     Get all articles older than a value of time in seconds stored in enum timeInSeconds
     
     - parameter article: HackerNewsArticle to be saved
     
     - returns: Return the managed object array of articles older than timeInSeconds parameter
     */
    class func getAllArticlesOlderThan(articleAge: timeInSeconds) throws -> [HackerManagedObject] {
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        
        // Fetch reqest for entity Person
        let fetchRequest = NSFetchRequest(entityName: HackerNewsConstants.coreDataEntities.HackerNewsModel)
        // Adding the predicate
        // 172800= 2 days in seconds, so articles less than this are two days old, then we purge
        let predicate = NSPredicate(format: "createdTimeSeconds < %@" , "\(Int64(NSDate().timeIntervalSince1970) - articleAge.rawValue))")
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
    
    /**
     Convert new Article stored from feed to a managedObject and return it
     
     - parameter article: HackerNewsArticle to be saved
     
     - returns: Return the managed object that was saved to be stored in our savedArticles array
     */
    class func saveNewArticle(article: HackerNewsArticle?) throws -> HackerManagedObject? {
        
        if let article = article {
            let managedContext = CoreDataManager.sharedInstance.managedObjectContext
            
            //Create a hacker news article managed object
            let hackerNewsArticle: HackerManagedObject = NSEntityDescription.insertNewObjectForEntityForName(HackerNewsConstants.coreDataEntities.HackerNewsModel, inManagedObjectContext: managedContext) as! HackerManagedObject
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
    
    
    /**
     Set an article userDeletedArticle flag to true, does not remove but means won't be displayed
     
     - parameter article: HackerManagedObject to be flagged as deleted
     
     - returns: if the Article is flagged succesfully as deleted returns true, else - false
     */
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
    
    /**
     Purge old articles so that coredata store does not keep growing
     
     - parameter articleAge: timeInSeconds age of article to be deleted stored in enum

     */
    class func purgeOldArticles(articleAge: timeInSeconds) {
        
        if let articles = try? HackerCoreDataManager.getAllArticlesOlderThan(articleAge) {
            for article in articles {
                print(NSDate().hoursFrom(article.createdTimeStampDate))
                let _ = try? HackerCoreDataManager.deleteArticle(article)
            }
        }
    }

    /**
     Delete an article from the core data store
     
     - parameter article: HackerManagedObject to be deleted
     
     - returns: if the Article is deleted returns true, else - false
     */
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
     
     - parameter storyID: storyID for the article to be verified
     
     - returns: if the Article is stored returns true, else - false
     */
    class func checkIfArticleAlreadyIsStored(storyID: Int) -> Bool {
        let managedContext = CoreDataManager.sharedInstance.managedObjectContext
        
        // Fetch reqest for entity Person
        let fetchRequest = NSFetchRequest(entityName: HackerNewsConstants.coreDataEntities.HackerNewsModel)
        
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
