//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/15/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import Foundation
import MapKit

extension ParseClient {

    func getStudentLocations(completionHandler: (success: Bool) -> Void) {

        let parameters = ["limit" : 100]

        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (JSONResult, error) in

            var success : Bool = false

            if let error = error {
                println("GET StudentLocation download error: \(error)")
                completionHandler(success: success)
            } else {

                //Example JSON response in "results" dictionary
                // {
                //    createdAt = "2015-07-11T18:23:26.897Z";
                //    firstName = Shawn;
                //    lastName = Spencer;
                //    latitude = "32.96076";
                //    longitude = "-96.73352";
                //    mapString = "Richardson, TX";
                //    mediaURL = "http://www.duckduckgo.com/";
                //    objectId = ydYfSI2bKv;
                //    uniqueKey = 328008541;
                //    updatedAt = "2015-07-16T17:06:05.403Z";
                // }

                self.locationList.removeAll(keepCapacity: true)

                if let resultsArray = JSONResult["results"] as? [[String:AnyObject]] {

                    for result in resultsArray {
                        if let firstName = result["firstName"] as? String,
                            let lastName  = result["lastName"] as? String,
                            let mediaUrl  = result["mediaURL"] as? String,
                            let locationString  = result["mapString"] as? String,
                            let lat = result["latitude"] as? Double,
                            let lon = result["longitude"] as? Double {

                                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)

                                // I found that some users have put "\n" inside their location string, but I don't want this to interfere with
                                // how I display the string in my app, so I remove all occurences of "\n"
                                let sanitizedLocationString = locationString.stringByReplacingOccurrencesOfString("\n", withString: " ")

                                let entry = StudentInformation(latLonLocation: location,
                                                               firstName: firstName,
                                                               lastName:  lastName,
                                                               mediaURL:  mediaUrl,
                                                               locationString: sanitizedLocationString)
                                self.locationList.append(entry)
                        }
                    }

                    println("Populated locationList with \(self.locationList.count) entries")
                    success = true
                }

                dispatch_async(dispatch_get_main_queue(), {
                    self.notifyLocationDataListeners()
                })

                completionHandler(success: success)
            }

        }

    }

}
