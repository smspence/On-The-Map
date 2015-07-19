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

    @IBOutlet weak var signUpLink: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var tapRecognizer = UITapGestureRecognizer(target: self, action: "signUpLinkTapped:")
        signUpLink.addGestureRecognizer(tapRecognizer)
    }

    func signUpLinkTapped(sender: UITapGestureRecognizer) {

        if sender.state == .Ended {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        }
    }

    func displayErrorAlert(errorString: String)
    {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)

            let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default) {
                action in self.dismissViewControllerAnimated(true, completion: nil)
            }

            controller.addAction(okAction)
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {

        if count(textFieldEmail.text) == 0 {
            self.displayErrorAlert("Please enter email address.")
            return
        } else if count(textFieldPassword.text) == 0 {
            self.displayErrorAlert("Please enter password.")
            return
        }

        UdacityClient.sharedInstance().authenticateWithUsername(textFieldEmail.text, password: textFieldPassword.text) { (loginSuccess, errorString) in
            if loginSuccess {
                ParseClient.sharedInstance().getStudentLocations() { success in
                    if !success {
                        println("Get student locations failed")
                    }
                    self.completeLogin()
                }
            } else {
                if let errorString = errorString {
                    self.displayErrorAlert(errorString)
                } else {
                    self.displayErrorAlert("Undefined error")
                }
            }
        }
    }

    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {

            println("userId: \(UdacityClient.sharedInstance().userID)")
            println("sessionId: \(UdacityClient.sharedInstance().sessionID)")
            println("user name: \(UdacityClient.sharedInstance().userFirstName) \(UdacityClient.sharedInstance().userLastName)")

            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

}

