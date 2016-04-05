//
//  HackNewsModel.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import Foundation
struct HackerNewsModel {
    var createdTimeStamp: NSDate
    var author: String
    var storyID:NSInteger
    var storyTitle: String
    var storyURL: NSURL
    
    init(hackerData: HackerData) {
        self.storyTitle = "No Title"
        self.author = "No Author"
        self.storyID = 1234
        self.storyURL = NSURL(string: "")!
        self.createdTimeStamp = NSDate()

        if let createdTimeStampString = hackerData["created_at"] as? String {
            let dateFormatter = NSDateFormatter()
            // 2016-04-03T14:31:43.000Z
            dateFormatter.dateFormat = "YYYY-MM-DDThh:mm:ss.000Z"
/*find out and place date format from http://userguide.icu-project.org/formatparse/datetime*/
            if let date = dateFormatter.dateFromString(createdTimeStampString) {
                self.createdTimeStamp = date
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