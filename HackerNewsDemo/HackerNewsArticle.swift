//
//  HackNewsModel.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import Foundation

struct HackerNewsArticle {
    var createdTimeStampDate: NSDate?
    var createdTimeSeconds: Int?
    var timeSinceCreatedInterval: String?
    var author: String?
    var storyID:Int?
    var storyTitle: String?
    var storyURL: String?
    var storyText: String?
    var userDeletedArticle: Bool!

    init(hackerData: HackerData) {
        self.userDeletedArticle = false
        if let createdTimeSecondsUnwrap = hackerData[HackerNewsConstants.jsonKeys.createdAtiKey] as? Int {
            self.createdTimeSeconds = createdTimeSecondsUnwrap
        }
        
        if let createdTimeStampString = hackerData[HackerNewsConstants.jsonKeys.createdAtKey] as? String {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 7200)
            print(dateFormatter.dateFromString(createdTimeStampString))
            
            if let date = dateFormatter.dateFromString(createdTimeStampString) {
                self.timeSinceCreatedInterval = NSDate().offsetFrom(date)
                self.createdTimeStampDate = date
            }
        }
        if let author = hackerData[HackerNewsConstants.jsonKeys.author] as? String {
            self.author = author
        }
        
        if let commentText = hackerData[HackerNewsConstants.jsonKeys.comment_text] as? String {
            self.storyText = commentText
        } else if let storyTextUnwrap = hackerData[HackerNewsConstants.jsonKeys.storyText] as? String {
            self.storyText = storyTextUnwrap
        }

        
        if let storyID = hackerData[HackerNewsConstants.jsonKeys.storyID] as? Int {
            self.storyID = storyID
        } else if let tags = hackerData[HackerNewsConstants.jsonKeys.tags] as? NSArray {
            let intString = tags[2].componentsSeparatedByCharactersInSet(
                NSCharacterSet
                    .decimalDigitCharacterSet()
                    .invertedSet)
                .joinWithSeparator("")
            self.storyID = Int(intString)
            print(self.storyID)
        }
        if let storyTitle = hackerData[HackerNewsConstants.jsonKeys.storyTitle] as? String ??  hackerData[HackerNewsConstants.jsonKeys.title] as? String {
            self.storyTitle = storyTitle
        }
        if let storyURL = hackerData[HackerNewsConstants.jsonKeys.storyURL] as? String ?? hackerData[HackerNewsConstants.jsonKeys.url] as? String {
            self.storyURL = storyURL
        } else if let tags = hackerData[HackerNewsConstants.jsonKeys.highlightResult] as? HackerData,
            let highlightresults = tags[HackerNewsConstants.jsonKeys.highlightResult] as? NSArray{
                for highlightresult in highlightresults {
                    if let highlightresult = highlightresult[HackerNewsConstants.jsonKeys.storyURL] {
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
        self.createdTimeStampDate = hackerArticle.createdTimeStampDate ?? NSDate()
        self.timeSinceCreatedInterval = hackerArticle.timeSinceCreatedInterval ?? "No time since created"
        self.author = hackerArticle.author ?? "No author"
        self.storyID = Int(hackerArticle.storyID) ?? -1
        self.storyTitle = hackerArticle.storyTitle ?? "No title"
        self.storyURL = hackerArticle.storyURL ?? "No story URL"
        self.storyText = hackerArticle.storyText ?? "No story text"
        self.userDeletedArticle = hackerArticle.userDeletedArticle
        self.createdTimeSeconds = Int(hackerArticle.createdTimeSeconds) ?? -1
    }

}