//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/14/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import Foundation

extension ParseClient {

    // MARK: - Constants
    struct Constants {

        // MARK: URLs
        static let BaseURLSecure : String = "https://api.parse.com/1/classes/"

        static let ApplicationID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey    : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

        static let HeaderFieldApplicationId : String = "X-Parse-Application-Id"
        static let HeaderFieldRESTApiKey    : String = "X-Parse-REST-API-Key"
    }

    // MARK: - Methods
    struct Methods {

        static let StudentLocation = "StudentLocation"

    }

    // MARK: - JSON Keys
    struct JSONKeys {

        static let FirstName : String = "firstName"
        static let LastName  : String = "lastName"
        static let MediaUrl  : String = "mediaURL"
        static let MapString : String = "mapString"
        static let Latitude  : String = "latitude"
        static let Longitude : String = "longitude"

        static let UniqueKey : String = "uniqueKey"

        // POST StudentLocation respone keys
        static let CreatedAt : String = "createdAt"
        static let ObjectId : String  = "objectId"
    }

}
