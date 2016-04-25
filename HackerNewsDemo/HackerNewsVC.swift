//
//  ViewController.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import UIKit

class HackerNewsTableViewController: UITableViewController {

    //Article to pass to detail view
    var hackerArticleToPass: HackerNewsArticle?

    //MARK: SavedArticle array that also refreshes our table on update so that it display new list of articles
    var savedArticles = [HackerManagedObject]() {
        didSet {
            //everytime savedarticles is added to or deleted from table is refreshed
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedArticles = try! HackerCoreDataManager.getAllArticles()
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(loadHackerNews(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.savedArticles = try! HackerCoreDataManager.getAllArticles()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Navigation, Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == HackerNewsConstants.segues.DetailHackerView) {
            // initialize new view controller and cast it as your view controller
            let detailView = segue.destinationViewController as! DetailHackerView
            // your new view controller should have property that will store passed value
            detailView.article = self.hackerArticleToPass
        }
    }
    
    //MARK: Load Hacker news table update data

    /**
     Load Hacker news on refresh when user pulls down on table view
     
     - parameter sender:AnyObject object that refreshes table
     */
    func loadHackerNews(sender:AnyObject) {
        HackerNewsAPIService.sharedInstance.loadFeed { (success, message, code) in
            if code == HackerNewsConstants.serverCodes.noConnection {
                self.displayAlertMessage(HackerNewsConstants.serverMessages.noConnection, alertDescription: "")
            }
            self.savedArticles = try! HackerCoreDataManager.getAllArticles()
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: HackerNewsConstants.tableCellIDs.HackerNewsCell)
            self.refreshControl!.endRefreshing()
        }
    }
}
//MARK: - UITableViewDataSource
extension HackerNewsTableViewController {

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "HackerNewsCell")
        let row = indexPath.row
        let newHackerData = self.savedArticles[row]
        let title = newHackerData.storyTitle
        let timeInterval = newHackerData.timeSinceCreatedInterval
        let author = newHackerData.author
        cell.textLabel?.text = title
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.detailTextLabel?.text = author + " - " + timeInterval
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedArticles.count;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let articleToDelete = self.savedArticles[indexPath.row]
            //set coredata flag to deleted so won't be displayed again
            let _ = try? HackerCoreDataManager.setArticleToDeleted(articleToDelete)
            self.savedArticles.removeAtIndex(indexPath.row)
        }
    }
}

// MARK: - UITableViewDelegate
extension HackerNewsTableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let hackerArticleManagedObject = self.savedArticles[indexPath.row]
        hackerArticleToPass = HackerNewsArticle(withHackerManagedObject: hackerArticleManagedObject)
        
        performSegueWithIdentifier(HackerNewsConstants.segues.DetailHackerView, sender: self)
    }
}
    


