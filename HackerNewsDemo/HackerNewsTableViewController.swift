//
//  ViewController.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import UIKit

class HackerNewsTableViewController: UITableViewController {

    var newHackerDataArray:[HackerNewsModel] = []
    var newHackerData: HackerNewsModel? //struct to hold data we get back
    @IBOutlet var hackerTable: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HackerNewsData.sharedInstance.loadFeed { (success) in
            if(success){
//                self.newHackerData = HackerNewsData.sharedInstance.newHackerDataArray
                self.newHackerDataArray = HackerNewsData.sharedInstance.newHackerDataArray
                self.hackerTable!.reloadData()
                self.hackerTable!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HackerNewsCell")
                self.view.reloadInputViews()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }

    //MARK UITableview methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "HackerNewsCell")
        let row = indexPath.row
        self.newHackerData = self.newHackerDataArray[row]
        cell.textLabel?.text = self.newHackerData!.storyTitle
        cell.detailTextLabel?.text = self.newHackerData!.author + " - " + self.newHackerData!.timeSinceCreatedInterval + " - " + self.newHackerData!.createdTimeStampDate
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newHackerDataArray.count;
    }
    
}

