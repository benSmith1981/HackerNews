//
//  ViewController.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import UIKit

class HackerNewsTableViewController: UITableViewController {

    var refreshTable:UIRefreshControl?
    @IBOutlet var hackerTable: UITableView?
    
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

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(loadHackerNews(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.hackerTable!.addSubview(self.refreshControl!)
//        if let refreshTable = UIRefreshControl() {
//            self.refreshTable.attributedTitle = NSAttributedString(string: "Pull to refresh")
//            self.refreshTable.addTarget(self, action: #selector(loadHackerNews(_:)), forControlEvents: UIControlEvents.ValueChanged)
//        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.savedArticles = try! HackerCoreDataManager.getAllArticles()
        self.hackerTable!.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    //MARK Load Hacker news on refresh
    
     func loadHackerNews(sender:AnyObject) {
        HackerNewsAPIService.sharedInstance.loadFeed { (success, message, code) in
            if(success){
                self.savedArticles = try! HackerCoreDataManager.getAllArticles()
                self.hackerTable!.reloadData()
                self.hackerTable!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HackerNewsCell")
                self.refreshControl?.endRefreshing()
            }
        }
    }

    //MARK UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "HackerNewsCell")
        let row = indexPath.row
//        if let newHackerData = self.savedArticles[row] {
//            if let title = newHackerData.storyTitle as? String,
//                let timeInterval = newHackerData.timeSinceCreatedInterval,
//                let author = newHackerData.author,
//                let timeStamp = newHackerData.createdTimeStampDate {
//                    cell.textLabel?.text = title
//                    cell.detailTextLabel?.text = author + " - " + timeInterval + " - " + timeStamp
//                }
//        }
        

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
            let _ = try? HackerCoreDataManager.deleteArticle(self.savedArticles[indexPath.row])
            self.savedArticles.removeAtIndex(indexPath.row)
            self.hackerTable!.reloadData()
        }
    }
    
}

