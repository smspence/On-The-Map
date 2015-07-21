//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/14/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import Foundation

protocol StudentLocationUpdateListener {
    func studentLocationDataUpdated()
}

class ParseClient : NSObject {

    // Shared data model
    var locationList = [StudentInformation]()

    var locationDataListeners = [StudentLocationUpdateListener]()

    // Shared session
    var session: NSURLSession

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    func addLocationDataListener(listener : StudentLocationUpdateListener) {
        locationDataListeners.append(listener)
    }

    func notifyLocationDataListeners() {
        for listener in locationDataListeners {
            listener.studentLocationDataUpdated()
        }

        println("Notified \(locationDataListeners.count) listeners")
    }

    // MARK: - GET

    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        /* 1. Set the parameters */
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + WebHelper.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.RESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                completionHandler(result: nil, error: downloadError)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }

        /* 7. Start the request */
        task.resume()
        
        return task
    }

    // MARK: - POST

    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        /* 1. Set the parameters */
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + WebHelper.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.RESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let error = downloadError {
                completionHandler(result: nil, error: downloadError)
            } else {
                ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }

        /* 7. Start the request */
        task.resume()

        return task
    }

    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {

        var parsingError: NSError? = nil

        let parsedResult : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)

        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }

    // MARK: - Shared Instance

    class func sharedInstance() -> ParseClient {

        struct Singleton {
            static var sharedInstance = ParseClient()
        }

        return Singleton.sharedInstance
    }
}
