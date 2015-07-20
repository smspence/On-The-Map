//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/19/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var informationPostingNavBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
