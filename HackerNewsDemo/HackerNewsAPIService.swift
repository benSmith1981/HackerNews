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

typealias APIResponse = (Bool) -> Void
typealias APIServiceResponse = (HackerData?, NSError?) -> Void

class HackerNewsAPIService {
    
    static let sharedInstance = HackerNewsAPIService()
    var newHackerData: HackerNewsArticle? //struct to hold data we get back
    var newHackerDataArray:[HackerNewsArticle] = []
    private var hackerInfoDict:HackerData = [:] //dictionary to hold data from json

    private init() {}
    
    /**
     Check if there is an active network connection for the device
     
     - returns: Network connetion status (Bool)
     */
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func loadFeed(onCompletion: APIResponse) {
        makeLoadrequest(hackerNewsPath, onCompletion: { json, err in
            if let json = json {
                //store the json in an object
                for jsonObject in (json["hits"] as? NSArray)!{
                    print(jsonObject)
                    self.newHackerData = HackerNewsArticle.init(hackerData: jsonObject as! HackerData)
                    self.newHackerDataArray.append(self.newHackerData!)
                }
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        })
    }
    
    func makeLoadrequest(path: String, onCompletion: APIServiceResponse){
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            do {
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                if let dict = jsonObject as? [String: AnyObject] {
                    if dict.count == 0 { //we get a response of nothing returned
                        onCompletion(nil, nil)
                    } else {
                        self.hackerInfoDict = dict //use this so the unit test has access to data returned
                        onCompletion(dict, nil)
                    }
                }
                
            }catch {
                print("error serializing JSON: \(error)")
                onCompletion(nil, nil)
            }
        })
        task.resume()
        
    }
}