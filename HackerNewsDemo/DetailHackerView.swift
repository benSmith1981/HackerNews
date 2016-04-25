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
        HackerNewsAPIService.sharedInstance.isConnectedToNetwork{ (success, message, code) in
            guard success else {
                self.displayAlertMessage(message!, alertDescription: "")
                return
            }
            self.newsWebView.delegate = self
            if let storyUrlString =  self.article!.storyURL,
                let urlUnwrap = NSURL (string: storyUrlString){
                let requestObj = NSURLRequest(URL: urlUnwrap);
                self.newsWebView.loadRequest(requestObj)
            } else { //no URL then try reconstruct the story into an html format
                if let storyTitleUnwrapped = self.article?.storyTitle,
                    let storyTextUnwrapped = self.article?.storyText{
                    let myHTML = "<html><body><h1>" + storyTitleUnwrapped + "</h1><h2>" + storyTextUnwrapped + "</h2></body></html>";
                    self.newsWebView.loadHTMLString(myHTML, baseURL: nil)
                } else if let storyTextUnwrapped = self.article?.storyText{
                    let myHTML = "<html><body><h1>Title</h1><h2>" + storyTextUnwrapped + "</h2></body></html>";
                    self.newsWebView.loadHTMLString(myHTML, baseURL: nil)
                }
            }
        }
    }
    
    /**
     Private function to pass webview data either as a URL to be loaded or an HTML body, also deals with no network connection
     
     - parameter: none
     
     - return: none
     */
    private func passWebViewData() {

    }
    //when webview is loaded stop the loading wheel and hide the view
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingView.hidden = true
        self.loadingWheel.stopAnimating()
    }
}