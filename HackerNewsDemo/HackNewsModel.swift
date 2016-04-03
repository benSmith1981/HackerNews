//
//  HackNewsModel.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import Foundation
struct HackerNewsModel {
    var createdTimeStamp: NSInteger
    var author: String
    var storyID:NSInteger
    var storyTitle: String
//    var storyURL: NSURL
    
    init(hackerData: HackerData) {

        if let createdTimeStamp = hackerData["created_at_i"] as? NSInteger,
            let author = hackerData["author"] as? String,
            let storyID = hackerData["story_id"] as? NSInteger,
            let storyTitle = hackerData["story_title"] as? String
        {
            self.createdTimeStamp = createdTimeStamp
            self.author = author
            self.storyID = storyID
            self.storyTitle = storyTitle

        }
        else {
            self.createdTimeStamp = 1234
            self.author = "Ben"
            self.storyID = 1234
            self.storyTitle = "ben"
        }
    }
}