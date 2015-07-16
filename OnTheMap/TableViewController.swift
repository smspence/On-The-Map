//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/14/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().hardCodedLocationData().count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("OTMTableViewReuseId") as! UITableViewCell
        let location = ParseClient.sharedInstance().hardCodedLocationData()[indexPath.row]

        // Set the name and image
        if let firstName = location["firstName"] as? String,
            let lastName  = location["lastName"] as? String {

                cell.textLabel?.text = firstName + " " + lastName
        } else {
            // TODO - remove, find better way to show error
            cell.textLabel?.text = "Error"
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Show the detail view of the selected location

//        detailViewIndexPath = indexPath
//
//        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewStoryboardId") as! MemeDetailViewController
//        detailVC.meme = self.memes[indexPath.item]
//        detailVC.deletionDelegate = self
//        detailVC.hidesBottomBarWhenPushed = true
//        self.navigationController!.pushViewController(detailVC, animated: true)
    }

}
