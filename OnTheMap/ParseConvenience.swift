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

    // Example for how to post a student location to Parse:
    //    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
    //    request.HTTPMethod = "POST"
    //    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    //    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    //    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //    request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
    //    let session = NSURLSession.sharedSession()
    //    let task = session.dataTaskWithRequest(request) { data, response, error in
    //        if error != nil { // Handle error…
    //            return
    //        }
    //        println(NSString(data: data, encoding: NSUTF8StringEncoding))
    //    }
    //    task.resume()

    func postStudentInformation(studentInfomation: StudentInformation, uniqueKey: String) {

        var studentInfoDictionary = studentInfomation.getDictionary()
        studentInfoDictionary[ParseClient.JSONKeys.UniqueKey] = uniqueKey

        taskForPOSTMethod(Methods.StudentLocation, parameters: [:], jsonBody: studentInfoDictionary) { (result: AnyObject!, error: NSError?) in

            println("TODO - implement")
        }

    }

    class func handleRefreshInViewController(viewController: UIViewController) {

        ParseClient.sharedInstance().getStudentLocations() { success in

            if !success {
                dispatch_async(dispatch_get_main_queue(), {
                    println("Get student locations failed")
                    WebHelper.displayStudentInformationDownloadErrorAlert(viewController)
                })
            }
        }
    }

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
                        self.locationList.append(StudentInformation(dictionary: result))
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
