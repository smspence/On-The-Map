//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/14/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit
import Foundation

extension UdacityClient {

    // MARK: - Authentication (GET) Methods
    /*
    Steps for Authentication...
    https://docs.google.com/document/d/1MECZgeASBDYrbBg7RlRu9zBBLGd3_kfzsN-0FtURqn0/pub?embedded=true

    To authenticate with Udacity, you simply need to get a session ID. This is accomplished by using Udacity’s session method.
    */
    func authenticateWithUsername(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {

        self.getSessionIdWithUsername(username, password: password) { (sessionIdSuccess, sessionID, userID, errorString) in

            if sessionIdSuccess {

                // Success! We have the sessionID and userID
                self.sessionID = sessionID
                self.userID = userID

                self.getUserData() { (success, firstName, lastName, userDataErrorString) in

                    if success {
                        self.userFirstName = firstName
                        self.userLastName  = lastName
                        completionHandler(success: true, errorString: nil)
                    } else {
                        completionHandler(success: false, errorString: userDataErrorString)
                    }
                }

            } else {
                completionHandler(success: sessionIdSuccess, errorString: errorString)
            }
        }
    }

    func getUserData(completionHandler: (success: Bool, firstName: String?, lastName: String?, errorString: String?) -> Void) {

        let methodName = WebHelper.subtituteKeyInMethod(Methods.UserData, key: "user_id", value: self.userID!)!

        taskForGETMethod(methodName, parameters: [:]) { JSONResult, error in

            if let error = error {
                println("getUserData taskForGETMethod error: \(error)")
                completionHandler(success: false, firstName: nil, lastName: nil, errorString: "User data download error")
            } else {

                if let userData = JSONResult[UdacityClient.JSONResponseKeys.User] as? [String : AnyObject],
                   let firstName = userData[UdacityClient.JSONResponseKeys.FirstName] as? String,
                   let lastName  = userData[UdacityClient.JSONResponseKeys.LastName] as? String {

                    completionHandler(success: true, firstName: firstName, lastName: lastName, errorString: nil)

                } else {
                    completionHandler(success: false, firstName: nil, lastName: nil, errorString: "User data JSON error")
                }
            }
        }
    }

    func getSessionIdWithUsername(username: String, password: String, completionHandler: (success: Bool, sessionID: String?, userID: String?, errorString: String?) -> Void) {

        /*
        Required in JSON body of POST session method:
            udacity - (Dictionary) a dictionary containing a username (email) and password pair used for authentication
                username - (String) the username (email) for a Udacity student
                password - (String) the password for a Udacity student
        */

        let jsonBody : [String:AnyObject] = [
            JSONBodyKeys.Udacity: [
                JSONBodyKeys.Username: username,
                JSONBodyKeys.Password: password
            ]
        ]

        taskForPOSTMethod(Methods.Session, parameters: [:], jsonBody: jsonBody) { JSONResult, error in

            if let error = error {
                println("getSessionIdWithUsername taskForPOSTMethod error: \(error)")
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session Error)")
            } else {

                /*
                Example JSON response from POST session method:
                {
                    "account":{
                        "registered":true,
                        "key":"3903878747"
                    },
                    "session":{
                        "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
                        "expiration":"2015-05-10T16:48:30.760460Z"
                    }
                }
                */

                if let sessionInfo = JSONResult[JSONResponseKeys.Session] as? [String : AnyObject],
                   let accountInfo = JSONResult[JSONResponseKeys.Account] as? [String : AnyObject] {

                    if let registered = accountInfo[JSONResponseKeys.Registered] as? Bool where registered == true,
                       let userID = accountInfo[JSONResponseKeys.Key] as? String,
                       let sessionID = sessionInfo[JSONResponseKeys.Id] as? String {

                        completionHandler(success: true, sessionID: sessionID, userID: userID, errorString: nil)

                    } else {
                        completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Invalid Account Info)")
                    }

                } else {
                    println("Session or account data not found in JSON:")
                    println("\(JSONResult)")
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Account not found or incorrect password")
                }
            }
        }

    }

}
