//
//  WebHelper.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/15/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit
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

    class func displayAlertMessage(message: String, viewController: UIViewController) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)

        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)

        controller.addAction(okAction)
        viewController.presentViewController(controller, animated: true, completion: nil)
    }

    class func displayStudentInformationDownloadErrorAlert(viewController: UIViewController) {
        displayAlertMessage("Error retrieving student information from web service", viewController: viewController)
    }

    class func displayInvalidUrlAlert(viewController: UIViewController) {
        displayAlertMessage("Invalid URL", viewController: viewController)
    }

    class func visitUrlString(urlString: String, fromViewController viewController: UIViewController) {

        var mutableUrlString = urlString.lowercaseString

        if (mutableUrlString.rangeOfString("http://") == nil) && (mutableUrlString.rangeOfString("https://") == nil) {
            mutableUrlString = "http://" + urlString
        }

        if let url = NSURL(string: mutableUrlString) {
            let app = UIApplication.sharedApplication()
            app.openURL(url)
        } else {
            displayInvalidUrlAlert(viewController)
        }
    }

}
