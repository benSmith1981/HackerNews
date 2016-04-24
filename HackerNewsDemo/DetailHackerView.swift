//
//  DetailHackerView.swift
//  HackerNewsDemo
//
//  Created by Ben Smith on 17/04/16.
//  Copyright © 2016 Ben Smith. All rights reserved.
//

import Foundation
import UIKit

class DetailHackerView: UIViewController, UIWebViewDelegate  {
 
    @IBOutlet var newsWebView: UIWebView!
    @IBOutlet var loadingWheel: UIActivityIndicatorView!
    @IBOutlet var loadingView: UIView!
    //MARK: Proprietes
    var article: HackerNewsArticle?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.hidden = false
        self.loadingWheel.startAnimating()
        
        self.newsWebView.frame = self.view.bounds
        self.newsWebView.scalesPageToFit = true

        self.loadingView.frame = self.view.bounds

        newsWebView.delegate = self
        if let storyUrlString =  article!.storyURL,
            let urlUnwrap = NSURL (string: storyUrlString){
                let requestObj = NSURLRequest(URL: urlUnwrap);
                newsWebView.loadRequest(requestObj)
        } else {
            let myHTML = "<html><head><title>" + (article?.storyTitle)! + "</title></head><body><h1>" + (article?.storyText)! + "</h1></body></html>";
            self.newsWebView.loadHTMLString(myHTML, baseURL: nil)
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {

    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingView.hidden = true
        self.loadingWheel.stopAnimating()

    }


}