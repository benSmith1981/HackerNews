//
//  Constants.swift
//  HackerNewsDemo
//
//  Created by Ben Smith on 05/04/16.
//  Copyright © 2016 Ben Smith. All rights reserved.
//

import Foundation

typealias ServerMessage = String
typealias ServerCode = String

struct HackerNewsConstants{
    
    struct jsonKeys{
        static let  createdAtKey = "created_at"
        static let  createdAtiKey = "created_at_i"
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
    
    struct serverMessages{
        static let OK = "Everything is OK"
        static let noConnection = "No network connection"
        static let noJsonReturned = "No JSON returned from request"
        static let needNetworkConnection = "Need Network connection"
        static let serverNotReachable = "Server not reachable"
        static let cannotConnectToServer = "Cannot connect to server"
        static let coreDataFail = "Core Data Failed to retrieve articles, and the network is down"
    }
    
    struct serverCodes{
        static let OK = "OK"
        static let noConnection = "NoConnection"
        static let noJsonReturned = "JsonNil"
        
    }
    
    struct responseCodes{
        static let ok200 = 200
        static let ok204 = 204
    }
    
    struct timeInSeconds{
        static let twoDaysInSeconds = 172800
        static let oneDaysInSeconds = 86400
        static let twoHoursInSeconds = 7200
    }

    struct nsuserdefaultKeys{
        static let deletedStoryIds = "deletedStoryIds"
    }
    
}