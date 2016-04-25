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

        newsWebView.delegate = self
        if let storyUrlString =  article!.storyURL,
            let urlUnwrap = NSURL (string: storyUrlString){
                let requestObj = NSURLRequest(URL: urlUnwrap);
                newsWebView.loadRequest(requestObj)
        } else { //no URL then try reconstruct the story into an html format
//            let myHTML = "<html><body><h1> " + (article?.storyTitle)! + "</h1><h2>" + (article?.storyText)! + "</h2></body></html>";
            let myHTML = "<html><body><h1>Title</h1><h2>" + (article?.storyText)! + "</h2></body></html>";

            self.newsWebView.loadHTMLString(myHTML, baseURL: nil)
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingView.hidden = true
        self.loadingWheel.stopAnimating()

    }


}