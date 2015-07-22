//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/12/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {

    /* Shared session */
    var session: NSURLSession

    /* Authentication state */
    var sessionID : String? = nil
    var userID : String? = nil

    /* User data */
    var userFirstName : String? = nil
    var userLastName  : String? = nil

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    // MARK: - GET

    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        /* 1. Set the parameters */
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + WebHelper.escapedParameters(parameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let downloadError = downloadError {
                completionHandler(result: nil, error: downloadError)
            } else {
                UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
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
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)

        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if let downloadError = downloadError {
                completionHandler(result: nil, error: downloadError)
            } else {
                UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }

        /* 7. Start the request */
        task.resume()

        return task
    }

    // MARK: - DELETE

    func taskForDELETESessionMethod(completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.Constants.BaseURLSecure + UdacityClient.Methods.Session)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }

        let task = session.dataTaskWithRequest(request) { data, response, downloadError in

            if let downloadError = downloadError {
                completionHandler(result: nil, error: downloadError)
            } else {
                UdacityClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }

        task.resume()

        return task
    }

    // MARK: - Helpers

    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {

        var parsingError: NSError? = nil

        /*
        Special Note on Udacity JSON Responses:

        FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
        These characters are used for security purposes. We subset the response data in order to skip over them.
        */
        let dataSubset = data.subdataWithRange(NSMakeRange(5, data.length - 5))

        let parsedResult : AnyObject? = NSJSONSerialization.JSONObjectWithData(dataSubset, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)

        if let error = parsingError {
            completionHandler(result: nil, error: error)
        } else {
            completionHandler(result: parsedResult, error: nil)
        }
    }

    // MARK: - Shared Instance

    class func sharedInstance() -> UdacityClient {

        struct Singleton {
            static var sharedInstance = UdacityClient()
        }

        return Singleton.sharedInstance
    }
}
