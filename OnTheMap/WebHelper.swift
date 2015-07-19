//
//  WebHelper.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/15/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import Foundation

class WebHelper : NSObject {

    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }

    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {

        var urlVars = [String]()

        for (key, value) in parameters {

            /* Make sure that it is a string value */
            let stringValue = "\(value)"

            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())

            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]

        }

        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }

}
