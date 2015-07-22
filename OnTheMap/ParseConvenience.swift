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

    func postStudentInformation(studentInfomation: StudentInformation, uniqueKey: String, completionHandler: (success: Bool) -> Void) {

        var studentInfoDictionary = studentInfomation.getDictionary()
        studentInfoDictionary[ParseClient.JSONKeys.UniqueKey] = uniqueKey

        taskForPOSTMethod(Methods.StudentLocation, parameters: [:], jsonBody: studentInfoDictionary) { (JSONResult, error) in

            var success = false

            if let error = error {
                println("POST StudentLocation error: \(error)")
            } else {

                //Example JSON response
                // {
                //     "createdAt":"2015-03-11T02:48:18.321Z",
                //     "objectId":"CDHfAy8sdp"
                // }

                if let createdAtString = JSONResult[ParseClient.JSONKeys.CreatedAt] as? String,
                    let objectIdString = JSONResult[ParseClient.JSONKeys.ObjectId] as? String {

                        println("POST StudentLocation successful")
                        println("createdAt: \(createdAtString)")
                        println("objectId: \(objectIdString)")

                        success = true
                }
            }

            // call completion handler on the main thread
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(success: success)
            }
        }

    }

    class func handleRefreshInViewController(viewController: UIViewController) {

        ParseClient.sharedInstance().getStudentLocations() { success in

            if !success {
                println("Get student locations failed")
                WebHelper.displayAlertMessage("Error retrieving student information from web service.", viewController: viewController)
            }
        }
    }

    func getStudentLocations(completionHandler: (success: Bool) -> Void) {

        let parameters = ["limit" : 100]

        taskForGETMethod(Methods.StudentLocation, parameters: parameters) { (JSONResult, error) in

            var success = false

            if let error = error {
                println("GET StudentLocation download error: \(error)")
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

                dispatch_async(dispatch_get_main_queue()) {
                    self.notifyLocationDataListeners()
                }
            }

            // call completion handler on the main thread
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(success: success)
            }
        }

    }

}
