//
//  ViewController.swift
//  ReignDesignDemo
//
//  Created by Ben Smith on 28/09/2015.
//  Copyright (c) 2015 Ben Smith. All rights reserved.
//

import UIKit

class HackerNewsTableViewController: UITableViewController {

    var newHackerData: HackerNewsModel? //struct to hold data we get back
    @IBOutlet var hackerTable: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HackerNewsData.sharedInstance.loadFeed { (success) in
            if(success){
                self.newHackerData = HackerNewsData.sharedInstance.newHackerData
                self.hackerTable!.reloadData()
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
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HackerNewsCell", forIndexPath: indexPath) 
        let row = indexPath.row
        if let title = self.newHackerData?.storyTitle {
            cell.textLabel?.text = title
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
}

