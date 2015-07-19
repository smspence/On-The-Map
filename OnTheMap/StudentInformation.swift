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

    init(dictionary: [String : AnyObject]) {
        if let fName = dictionary["firstName"] as? String,
            let lName  = dictionary["lastName"] as? String,
            let url  = dictionary["mediaURL"] as? String,
            let lString  = dictionary["mapString"] as? String,
            let lat = dictionary["latitude"] as? Double,
            let lon = dictionary["longitude"] as? Double {

                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)

                // I found that some users have put "\n" inside their location string, but I don't want this to interfere with
                // how I display the string in my app, so I remove all occurences of "\n"
                let sanitizedLocationString = lString.stringByReplacingOccurrencesOfString("\n", withString: " ")

                latLonLocation = location
                firstName = fName
                lastName = lName
                mediaURL = url
                locationString = sanitizedLocationString
        }
    }
}
