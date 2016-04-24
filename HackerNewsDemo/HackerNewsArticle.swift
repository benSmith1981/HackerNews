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
    static let  comment_text = "comment_text"
    static let  storyID = "story_id"
    static let  storyTitle = "story_title"
    static let  storyText = "story_text"

    static let  title = "title"
    static let  tags = "_tags"
    static let  storyURL = "story_url"
    static let  url = "url"
    static let  highlightResult = "_highlightResult"
}

struct HackerNewsArticle {
    var createdTimeStampDate: String?
    var timeSinceCreatedInterval: String?
    var author: String?
    var storyID:Int?
    var storyTitle: String?
    var storyURL: String?
    var storyText: String?
    
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
        
        if let commentText = hackerData[jsonKeys.comment_text] as? String {
            self.storyText = commentText
        } else if let storyTextUnwrap = hackerData[jsonKeys.storyText] as? String {
            self.storyText = storyTextUnwrap
        }

        
        if let storyID = hackerData[jsonKeys.storyID] as? Int {
            self.storyID = storyID
        } else if let tags = hackerData[jsonKeys.tags] as? NSArray {
            let intString = tags[2].componentsSeparatedByCharactersInSet(
                NSCharacterSet
                    .decimalDigitCharacterSet()
                    .invertedSet)
                .joinWithSeparator("")
            self.storyID = Int(intString)
            print(self.storyID)
        }
        if let storyTitle = hackerData[jsonKeys.storyTitle] as? String ??  hackerData[jsonKeys.title] as? String {
            self.storyTitle = storyTitle
        }
        if let storyURL = hackerData[jsonKeys.storyURL] as? String ?? hackerData[jsonKeys.url] as? String {
            self.storyURL = storyURL
        } else if let tags = hackerData[jsonKeys.highlightResult] as? HackerData,
            let highlightresults = tags[jsonKeys.highlightResult] as? NSArray{
                for highlightresult in highlightresults {
                    if let highlightresult = highlightresult[jsonKeys.storyURL] {
                        print(highlightresult)
                    }
                }
        }
    }
    
    /**
     Constructor witch convert a CoreData HackerManagedObject to a regulary object
     
     - parameter hackerArticle: HackerManagedObject
     
     - returns: no return
     */
    init(withHackerManagedObject hackerArticle: HackerManagedObject) {
        self.createdTimeStampDate = hackerArticle.createdTimeStampDate ?? "No time stamp"
        self.timeSinceCreatedInterval = hackerArticle.timeSinceCreatedInterval ?? "No time since created"
        self.author = hackerArticle.author ?? "No author"
        self.storyID = Int(hackerArticle.storyID) ?? -1
        self.storyTitle = hackerArticle.storyTitle ?? "No title"
        self.storyURL = hackerArticle.storyURL ?? "No story URL"
        self.storyText = hackerArticle.storyText ?? "No story text"

    }

}