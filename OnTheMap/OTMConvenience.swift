//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/14/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit
import Foundation

extension OTMClient {

    // MARK: - Authentication (GET) Methods
    /*
    Steps for Authentication...
    https://docs.google.com/document/d/1MECZgeASBDYrbBg7RlRu9zBBLGd3_kfzsN-0FtURqn0/pub?embedded=true

    To authenticate with Udacity, you simply need to get a session ID. This is accomplished by using Udacity’s session method.
    */
    func authenticateWithUsername(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {

        // TODO - pass username and password into getSessionID()?
        self.getSessionIdWithUsername(username, password: password) { (success, sessionID, userID, errorString) in

            if success {

                // Success! We have the sessionID and userID
                self.sessionID = sessionID
                self.userID = userID

                completionHandler(success: success, errorString: errorString)

            } else {
                completionHandler(success: success, errorString: errorString)
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
                    println("Error reading JSON:")
                    println("\(JSONResult)")
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Account not found)")
                }
            }
        }

    }

}
