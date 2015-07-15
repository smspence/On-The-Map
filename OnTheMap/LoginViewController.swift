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

        OTMClient.sharedInstance().authenticateWithUsername(textFieldEmail.text, password: textFieldPassword.text) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }

    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.errorMessageLabel.text = ""
//            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
//            self.presentViewController(controller, animated: true, completion: nil)

            self.errorMessageLabel.text = "Login successful :)" // TODO - remove
            println("userId: \(OTMClient.sharedInstance().userID)")
            println("sessionId: \(OTMClient.sharedInstance().sessionID)")
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

