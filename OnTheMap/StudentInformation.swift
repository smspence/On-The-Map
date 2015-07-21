//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/16/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import Foundation
import MapKit

struct StudentInformation {

    var latLonLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var firstName : String = ""
    var lastName : String  = ""
    var mediaURL : String  = ""
    var locationString : String = ""

    init(latLonLocation: CLLocationCoordinate2D,
        firstName: String,
        lastName:  String,
        mediaURL:  String,
        locationString: String) {

            self.latLonLocation = latLonLocation
            self.firstName      = firstName
            self.lastName       = lastName
            self.mediaURL       = mediaURL
            self.locationString = locationString
    }

    init(dictionary: [String : AnyObject]) {

        if let firstName  = dictionary[ParseClient.JSONKeys.FirstName] as? String,
            let lastName  = dictionary[ParseClient.JSONKeys.LastName] as? String,
            let url       = dictionary[ParseClient.JSONKeys.MediaUrl] as? String,
            let locationString = dictionary[ParseClient.JSONKeys.MapString] as? String,
            let lat = dictionary[ParseClient.JSONKeys.Latitude] as? Double,
            let lon = dictionary[ParseClient.JSONKeys.Longitude] as? Double {

                let locationCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)

                // I found that some users have put "\n" inside their location string, but I don't want this to interfere with
                // how I display the string in my app, so I remove all occurences of "\n"
                let sanitizedLocationString = locationString.stringByReplacingOccurrencesOfString("\n", withString: " ")

                self.latLonLocation = locationCoordinate
                self.firstName      = firstName
                self.lastName       = lastName
                self.mediaURL       = url
                self.locationString = sanitizedLocationString
        }
    }

    func getDictionary() -> [String : AnyObject] {

        return [
            ParseClient.JSONKeys.FirstName : firstName,
            ParseClient.JSONKeys.LastName  : lastName,
            ParseClient.JSONKeys.MediaUrl  : mediaURL,
            ParseClient.JSONKeys.MapString : locationString,
            ParseClient.JSONKeys.Latitude  : latLonLocation.latitude,
            ParseClient.JSONKeys.Longitude : latLonLocation.longitude
        ]
    }

}
