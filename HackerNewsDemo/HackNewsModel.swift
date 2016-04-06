//
//  HackNewsModel.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import Foundation

struct HackerNewsModel {
    var createdTimeStampDate: String
    var timeSinceCreatedInterval: String
    var author: String
    var storyID:NSInteger
    var storyTitle: String
    var storyURL: NSURL
    
    init(hackerData: HackerData) {
        self.storyTitle = "No Title"
        self.author = "No Author"
        self.storyID = 1234
        self.storyURL = NSURL(string: "")!
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
        
        if let storyURL = hackerData["story_url"] as? NSURL {
            self.storyURL = storyURL
        } else if let url = hackerData["url"] as? NSURL {
            self.storyURL = url
        }
    }
}