//
//  HackerNewsDataController.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import Foundation
import SystemConfiguration

let hackerNewsPath = "http://hn.algolia.com/api/v1/search_by_date?query=ios"
public typealias HackerData = [String: AnyObject]

typealias APIResponse = (Bool, ServerMessage?, ServerCode?) -> Void
typealias APIServiceResponse = (Bool, HackerData?, ServerMessage?, ServerCode?, NSError?) -> Void

class HackerNewsAPIService {
    
    private var serverMessage: ServerMessage?
    private var serverCode: ServerCode?
    static let sharedInstance = HackerNewsAPIService()
    private var newHackerData: HackerNewsArticle? //struct to hold data we get back
    var newHackerDataArray:[HackerManagedObject] = []
    private var hackerInfoDict:HackerData = [:] //dictionary to hold data from json

    private init() {}
    
    func isConnectedToNetwork(networkCheckResponse: APIResponse) {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            networkCheckResponse(false, HackerNewsConstants.serverMessages.cannotConnectToServer, nil)
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        if !isReachable {
            networkCheckResponse(false, HackerNewsConstants.serverMessages.serverNotReachable, nil)
        }
        
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        if needsConnection {
            networkCheckResponse(false, HackerNewsConstants.serverMessages.needNetworkConnection, nil)
        }
        networkCheckResponse(true, HackerNewsConstants.serverMessages.OK, nil)
    }
    
    func APIServiceCheck(onCompletion: APIResponse) {
        //check for network connection
        isConnectedToNetwork { (success, message, code) in
            guard success else {
                //if it fails then send messages back saying no connection
                onCompletion(false, message, code)
                return
            }
            //initialise server code and messages to OK
            self.serverMessage = HackerNewsConstants.serverMessages.OK
            self.serverCode = HackerNewsConstants.serverCodes.OK
            //if not then return success
            onCompletion(true, self.serverMessage, self.serverCode)
        }
    }
}

//MARK: - load HackerNewsAPIService
extension HackerNewsAPIService {
    
    func loadFeed(onCompletion: APIResponse) {
        APIServiceCheck { (success, message, code) in
            if success {
                self.makeLoadrequest(hackerNewsPath, onCompletion: { success, json, serverMessage, serverCode, err in
                    if let json = json {
                        guard success == true else {
                            //request failed for some reason, but we have a json
                            onCompletion(false, serverMessage, serverCode)
                            return
                        }
                        //iterate our objects to store
                        for jsonObject in (json["hits"] as? NSArray)!{
                            print(jsonObject)
                            //creat new object
                            self.newHackerData = HackerNewsArticle.init(hackerData: jsonObject as! HackerData)
                            //send object ot coredata for storage
                            if let hackerData = self.newHackerData {
                                self.saveArticle(hackerData)
                            }
                        }
                        //success
                        onCompletion(true, serverMessage, serverCode)
                    } else { //json empty, request failed
                        onCompletion(false, serverMessage, serverCode)
                    }
                })
            } else {
                //Service check failed, no network connection
                do {
                    self.newHackerDataArray = try self.getAllArticles()
                    onCompletion(false, HackerNewsConstants.serverMessages.coreDataFail, nil)
                } catch{
                    onCompletion(false, HackerNewsConstants.serverMessages.coreDataFail, nil)
                }
                
            }
        }
    }
}
//MARK: CoreData Functions
extension HackerNewsAPIService {

    func saveArticle(article: HackerNewsArticle) {
//        if !HackerCore .checkIfTrackAlreadyIsStored(trackId) {
        do {
            if !HackerCoreDataManager.checkIfArticleAlreadyIsStored(article.storyID!) {
                try HackerCoreDataManager.saveNewArticle(article)
            }
        }
        catch {
            print(error)
        }
    }
    
    func getAllArticles() throws -> [HackerManagedObject] {
        do {
            let HackerNewsArticles = try HackerCoreDataManager.getAllArticles()
            return HackerNewsArticles
        }
        catch {
            throw error
        }
    }
    
}

//MARK: - load Load Request returning json
extension HackerNewsAPIService {
    private func makeLoadrequest(path: String, onCompletion: APIServiceResponse){
        
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if let response = response, let httpResponse = response as? NSHTTPURLResponse {
                let code = httpResponse.statusCode
                do {
                    //unserialise json
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    print(jsonObject)
                    
                    if case HackerNewsConstants.responseCodes.ok200 ... HackerNewsConstants.responseCodes.ok204 = code { // successful you get 200 to 204 back, anything else...Houston we gotta a problem
                        if let jsonObjectUnwrapped = jsonObject as? [String: AnyObject] {
                            onCompletion(true, jsonObjectUnwrapped, HackerNewsConstants.serverMessages.OK, String(code), nil)
                        }
                    } else {
                        print("error Code: \(code)")
                        if let jsonObjectUnwrapped = jsonObject as? [String: AnyObject] {
                            onCompletion(false, jsonObjectUnwrapped, HackerNewsConstants.serverMessages.OK, String(code), error)
                        }
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    if case HackerNewsConstants.responseCodes.ok200 ... HackerNewsConstants.responseCodes.ok204 = code {
                        onCompletion(true, nil, HackerNewsConstants.serverMessages.OK, String(code), nil)
                    } else {
                        print("error Code: \(code)")
                        onCompletion(false, nil, HackerNewsConstants.serverMessages.OK, String(code), nil)
                    }
                }
            }
        })
        task.resume()
        
    }
}