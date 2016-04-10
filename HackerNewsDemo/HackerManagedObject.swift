//
//  HackNewsModel.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import Foundation
import CoreData

typealias TimeStamp = String
typealias Author = String
typealias StoryID = Int64
typealias StoryTitle = String
typealias StoryURL = String

class HackerManagedObject: NSManagedObject {
    @NSManaged var createdTimeStampDate: TimeStamp
    @NSManaged var timeSinceCreatedInterval: TimeStamp
    @NSManaged var author: Author
    @NSManaged var storyID: StoryID
    @NSManaged var storyTitle: StoryTitle
    @NSManaged var storyURL: StoryURL
    
    func cloneFromHackerNewsModel(articleObject hackerArticle:HackerNewsArticle) {
        
        // Set the needed values from hacker news model object
        self.createdTimeStampDate = hackerArticle.createdTimeStampDate ?? "No time stamp"
        self.timeSinceCreatedInterval = hackerArticle.timeSinceCreatedInterval ?? "No time since created"
        self.author = hackerArticle.author ?? "No author"
        self.storyID = Int64(hackerArticle.storyID!) ?? -1
        self.storyTitle = hackerArticle.storyTitle ?? "No title"
        self.storyURL = hackerArticle.storyURL ?? "No story URL"
        
    }
    
}