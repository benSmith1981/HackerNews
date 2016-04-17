//
//  ViewController.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import UIKit

class HackerNewsTableViewController: UIViewController {

    var refreshTable:UIRefreshControl!
    @IBOutlet var hackerTable: UITableView!
    var hackerArticleToPass: HackerNewsArticle?

    //MARK: Proprietes
    var savedArticles = [HackerManagedObject]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                self.hackerTable!.reloadData()
                
                //If is empty we showing the infoView with No Data message
//                if(self.savedSongs.isEmpty) {
//                    self.infoView.setInfoViewActive(true, withText: self.infoView.kNoSavedSongsInfoMessage)
//                }
//                else
//                {
//                    self.infoView.setInfoViewActive(false, withText: nil)
//                    self.tableView.reloadData()
//                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedArticles = try! HackerCoreDataManager.getAllArticles()

        self.refreshTable = UIRefreshControl()
        self.refreshTable.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshTable.addTarget(self, action: #selector(loadHackerNews(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.hackerTable!.addSubview(self.refreshTable!)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.savedArticles = try! HackerCoreDataManager.getAllArticles()
        self.hackerTable!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "DetailHackerView") {
            // initialize new view controller and cast it as your view controller
            //let detailView = segue.destinationViewController as! DetailHackerView
            let navVC = segue.destinationViewController as! UINavigationController
            let detailView = navVC.topViewController
            // your new view controller should have property that will store passed value
//            detailView.article = self.hackerArticleToPass
        }
    }
    
    func functionToPassAsAction() {
        var controller: UINavigationController
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("DetailHackerView") as! UINavigationController
//        controller.yourTableViewArray = localArrayValue
//        controller.article = self.hackerArticleToPass
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK Load Hacker news on refresh
    
     func loadHackerNews(sender:AnyObject) {
        HackerNewsAPIService.sharedInstance.loadFeed { (success, message, code) in
            if(success){
                self.savedArticles = try! HackerCoreDataManager.getAllArticles()
                self.hackerTable!.reloadData()
                self.hackerTable!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HackerNewsCell")
                self.refreshTable?.endRefreshing()
            }
        }
    }
}

extension HackerNewsTableViewController: UITableViewDataSource {

    //MARK UITableViewDataSource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "HackerNewsCell")
        let row = indexPath.row
        let newHackerData = self.savedArticles[row]
        let title = newHackerData.storyTitle
        let timeInterval = newHackerData.timeSinceCreatedInterval
        let author = newHackerData.author
        let timeStamp = newHackerData.createdTimeStampDate
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = author + " - " + timeInterval + " - " + timeStamp
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedArticles.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let _ = try? HackerCoreDataManager.deleteArticle(self.savedArticles[indexPath.row])
            self.savedArticles.removeAtIndex(indexPath.row)
            self.hackerTable!.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension HackerNewsTableViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.hackerTable.deselectRowAtIndexPath(indexPath, animated: true)
        
        let hackerArticleManagedObject = self.savedArticles[indexPath.row]
        hackerArticleToPass = HackerNewsArticle(withHackerManagedObject: hackerArticleManagedObject)
        
        performSegueWithIdentifier("DetailHackerView", sender: self)
    }
}
    


