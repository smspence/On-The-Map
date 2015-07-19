//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/14/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, StudentLocationUpdateListener {

    @IBOutlet weak var locationTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        ParseClient.sharedInstance().addLocationDataListener(self)

        locationTable.reloadData()
    }

    func studentLocationDataUpdated() {
        println("TableViewController studentLocationDataUpdated() called")
        locationTable.reloadData()
    }

    @IBAction func refreshButtonTapped(sender: AnyObject) {

        ParseClient.sharedInstance().getStudentLocations() { success in

            if !success {
                println("Get student locations failed")
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().locationList.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("OTMTableViewReuseId") as! UITableViewCell
        let location = ParseClient.sharedInstance().locationList[indexPath.row]

        cell.textLabel?.text = location.firstName + " " + location.lastName

        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = location.locationString + ", " + location.mediaURL
        }

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let urlString = ParseClient.sharedInstance().locationList[indexPath.row].mediaURL

        WebHelper.visitUrlString(urlString, fromViewController: self)
    }

}
