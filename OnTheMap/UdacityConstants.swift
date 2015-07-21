//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/12/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

extension UdacityClient {

    // MARK: - Constants
    struct Constants {

        // MARK: URLs
        static let BaseURLSecure : String = "https://www.udacity.com/api/"

    }

    // MARK: - Methods
    struct Methods {

        // MARK: Account
        static let UserData = "users/{user_id}"

        // MARK: Authentication
        static let Session = "session"

    }

    // MARK: - JSON Body Keys
    struct JSONBodyKeys {

        static let Udacity  = "udacity"
        static let Username = "username"
        static let Password = "password"

    }

    // MARK: - JSON Response Keys
    struct JSONResponseKeys {

        // MARK: Authorization
        static let Session    = "session"
        static let Id         = "id"
        static let Expiration = "expiration"
        static let Account    = "account"
        static let Registered = "registered"
        static let Key        = "key"

        // MARK: User Data
        static let User      = "user"
        static let FirstName = "first_name"
        static let LastName  = "last_name"

    }

}
