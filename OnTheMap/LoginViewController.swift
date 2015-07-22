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

    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var signUpLink: UILabel!

    var tapRecognizer : UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let linkTapRecognizer = UITapGestureRecognizer(target: self, action: "signUpLinkTapped:")
        signUpLink.addGestureRecognizer(linkTapRecognizer)

        textFieldEmail.keyboardType = UIKeyboardType.EmailAddress

        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1

        loginButton.setTitle("Logging In...", forState: UIControlState.Disabled)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // When we wind up back at the login view (after logging out),
        //  make sure the Parse location data listeners are reset
        ParseClient.sharedInstance().removeLocationDataListeners()

        addKeyboardDismissRecognizer()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardDismissRecognizer()
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        // Reset UI elements back to default state, so they
        //  will appear in default state next time the user
        //  sees the login page (after logging out)
        textFieldEmail.text    = ""
        textFieldPassword.text = ""
        loginButton.enabled = true
    }

    func addKeyboardDismissRecognizer() {

        self.view.addGestureRecognizer(tapRecognizer)
    }

    func removeKeyboardDismissRecognizer() {

        self.view.removeGestureRecognizer(tapRecognizer)
    }

    func endAllTextBoxEditing() {
        self.view.endEditing(true)
    }

    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            endAllTextBoxEditing()
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        return true
    }

    func signUpLinkTapped(sender: UITapGestureRecognizer) {

        if sender.state == .Ended {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
        }
    }

    func displayErrorAlert(errorString: String)
    {
        let controller = UIAlertController(title: "Error", message: errorString, preferredStyle: UIAlertControllerStyle.Alert)

        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)

        controller.addAction(okAction)
        self.presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {

        endAllTextBoxEditing()

        if count(textFieldEmail.text) == 0 {
            self.displayErrorAlert("Please enter email address.")
            return
        } else if count(textFieldPassword.text) == 0 {
            self.displayErrorAlert("Please enter password.")
            return
        }

        loginButton.enabled = false

        UdacityClient.sharedInstance().authenticateWithUsername(textFieldEmail.text, password: textFieldPassword.text) { (loginSuccess, errorString) in

            if loginSuccess {

                println("userId: \(UdacityClient.sharedInstance().userID)")
                println("sessionId: \(UdacityClient.sharedInstance().sessionID)")
                println("user name: \(UdacityClient.sharedInstance().userFirstName) \(UdacityClient.sharedInstance().userLastName)")

                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
                self.presentViewController(controller, animated: true, completion: {
                    // After the map tab bar controller has been presented, refresh the student location data
                    ParseClient.handleRefreshInViewController(controller)
                })

            } else {

                self.loginButton.enabled = true

                if let errorString = errorString {
                    self.displayErrorAlert(errorString)
                } else {
                    self.displayErrorAlert("Undefined error")
                }
            }
        }
    }

}

