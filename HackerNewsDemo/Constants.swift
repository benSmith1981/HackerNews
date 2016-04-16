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

}