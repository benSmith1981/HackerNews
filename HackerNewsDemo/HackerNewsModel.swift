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
typealias StoryID = NSInteger
typealias StoryTitle = String
typealias StoryURL = NSURL

class HackerNewsModel: NSManagedObject {
    @NSManaged var createdTimeStampDate: TimeStamp
    @NSManaged var timeSinceCreatedInterval: TimeStamp
    @NSManaged var author: Author
    @NSManaged var storyID: StoryID
    @NSManaged var storyTitle: StoryTitle
    @NSManaged var storyURL: String
    
    init(hackerData: HackerData) {
        self.storyTitle = "No Title"
        self.author = "No Author"
        self.storyID = 1234
        self.storyURL = ""
        self.createdTimeStampDate = ""
        self.timeSinceCreatedInterval = ""
        

        if let createdTimeStampString = hackerData["created_at"] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 7200)
            print(dateFormatter.dateFromString(createdTimeStampString))
            
            if let date = dateFormatter.dateFromString(createdTimeStampString) {
                self.timeSinceCreatedInterval = NSDate().offsetFrom(date)
                self.createdTimeStampDate = createdTimeStampString
            }
        }
        
        if let author = hackerData["author"] as? String{
            self.author = author
        }
        
        if let storyID = hackerData["story_id"] as? NSInteger {
            self.storyID = storyID
        }
        
        if let storyTitle = hackerData["story_title"] as? String {
            self.storyTitle = storyTitle
        } else if let storyTitle = hackerData["title"] as? String{
            self.storyTitle = storyTitle
        }
        
        if let storyURL = hackerData["story_url"] as? String {
            self.storyURL = storyURL
        } else if let url = hackerData["url"] as? String {
            self.storyURL = url
        }
    }
}