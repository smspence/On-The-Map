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
    @IBOutlet weak var tableViewNavBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        addRightBarButtonItems()

        ParseClient.sharedInstance().addLocationDataListener(self)
    }

    func addRightBarButtonItems() {
        var navItem = tableViewNavBar.items[0] as! UINavigationItem

        var buttons = [UIBarButtonItem]()

        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshButtonTapped:")
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addLocationButtonTapped:")

        buttons.append(refreshButton)
        buttons.append(addLocationButton)
        navItem.setRightBarButtonItems(buttons, animated: false)
    }

    func studentLocationDataUpdated() {
        println("TableViewController studentLocationDataUpdated() called")
        locationTable.reloadData()
    }

    func refreshButtonTapped(sender: AnyObject) {

        ParseClient.handleRefreshInViewController(self)
    }

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        println("logoutButtonTapped")
    }

    func addLocationButtonTapped(sender: AnyObject) {

        println("addLocationButtonTapped")
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
