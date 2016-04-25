//
//  HackNewsModel.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import Foundation
import CoreData

typealias TimeStampString = String
typealias Author = String
typealias StoryID = Int64
typealias StoryTitle = String
typealias StoryURL = String

class HackerManagedObject: NSManagedObject {
    @NSManaged var createdTimeStampDate: NSDate
    @NSManaged var createdTimeSeconds: Int64
    @NSManaged var timeSinceCreatedInterval: TimeStampString
    @NSManaged var author: Author
    @NSManaged var storyID: StoryID
    @NSManaged var storyTitle: StoryTitle
    @NSManaged var storyURL: StoryURL
    @NSManaged var storyText: String
    @NSManaged var userDeletedArticle: Bool

    /**
     Clone an article saved in the feed object to a managed object for storage
     
     - parameter hackerArticle: HackerNewsArticle to clone to managed object
     */
    func cloneFromHackerNewsModel(hackerArticle: HackerNewsArticle) {
        
        // Set the needed values from hacker news model object
        self.createdTimeStampDate = hackerArticle.createdTimeStampDate ?? NSDate()
        self.timeSinceCreatedInterval = hackerArticle.timeSinceCreatedInterval ?? "No time since created"
        self.author = hackerArticle.author ?? "No author"
        self.storyID = Int64(hackerArticle.storyID!) ?? -1
        self.storyTitle = hackerArticle.storyTitle ?? "No title"
        self.storyURL = hackerArticle.storyURL ?? "No story URL"
        self.storyText = hackerArticle.storyText ?? "No Text"
        self.userDeletedArticle = hackerArticle.userDeletedArticle
        self.createdTimeSeconds = Int64(hackerArticle.createdTimeSeconds!) ?? -1
    }
    
}