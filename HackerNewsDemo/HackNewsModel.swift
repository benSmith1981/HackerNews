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
        createdTimeStamp = hackerData["created_at_i"] as! NSInteger
        author = hackerData["author"] as! String
        storyID = hackerData["story_id"] as! NSInteger
        storyTitle = hackerData["story_title"] as! String
//        storyURL = (hackerData["story_url"] as? NSURL)!
    }
}