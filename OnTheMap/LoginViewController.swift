//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/11/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {

        if count(textFieldEmail.text) == 0 {
            self.errorMessageLabel.text = "Please enter email address."
            return
        } else if count(textFieldPassword.text) == 0 {
            self.errorMessageLabel.text = "Please enter password."
            return
        } else {
            self.errorMessageLabel.text = ""
        }

        UdacityClient.sharedInstance().authenticateWithUsername(textFieldEmail.text, password: textFieldPassword.text) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }

    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {

            println("userId: \(UdacityClient.sharedInstance().userID)")
            println("sessionId: \(UdacityClient.sharedInstance().sessionID)")

            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.errorMessageLabel.text = errorString
            }
        })
    }

}

