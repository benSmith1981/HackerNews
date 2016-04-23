//
//  DetailHackerView.swift
//  HackerNewsDemo
//
//  Created by Ben Smith on 17/04/16.
//  Copyright © 2016 Ben Smith. All rights reserved.
//

import Foundation
import UIKit

class DetailHackerView: UIViewController {
 
    @IBOutlet var newsWebView: UIWebView!
    //MARK: Proprietes
    var article: HackerNewsArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlUnwrap =  article!.storyURL {
            let url = NSURL (string: urlUnwrap)
            let requestObj = NSURLRequest(URL: url!);
            newsWebView.loadRequest(requestObj)
        }
    }
}