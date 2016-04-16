//
//  HackNewsModel.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import Foundation

struct jsonKeys{
    static let  createdAtKey = "created_at"
    static let  author = "author"
    static let  storyID = "story_id"
    static let  storyTitle = "story_title"
    static let  title = "title"
    static let  tags = "_tags"
    static let  storyURL = "story_url"
    static let  url = "url"
}

struct HackerNewsArticle {
    var createdTimeStampDate: String?
    var timeSinceCreatedInterval: String?
    var author: String?
    var storyID:Int?
    var storyTitle: String?
    var storyURL: String?
    
    init(hackerData: HackerData) {
        if let createdTimeStampString = hackerData[jsonKeys.createdAtKey] as? String {
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
        if let author = hackerData[jsonKeys.author] as? String {
            self.author = author
        }
        if let storyID = hackerData[jsonKeys.storyID] as? Int {
            self.storyID = storyID
        }
        if let tags = hackerData[jsonKeys.tags] as? NSArray {
            let numbersAsStrings = matchesForRegexInText("\\d+", tags[2] as! String) // [String]
            let numbersAsInts = numbersAsStrings.map { $0.toInt()! }  // [Int]
            print(tags)
        }
        if let storyTitle = hackerData[jsonKeys.storyTitle] as? String ??  hackerData[jsonKeys.title] as? String {
            self.storyTitle = storyTitle
        }
        if let storyURL = hackerData[jsonKeys.storyURL] as? String ?? hackerData[jsonKeys.url] as? String {
            self.storyURL = storyURL
        }
    }
}