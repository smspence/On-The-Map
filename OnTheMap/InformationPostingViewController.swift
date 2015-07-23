//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/19/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var informationPostingNavBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var whereAreYouStudyingLabel: UILabel!

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pleaseEnterUrlLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let geocoder = CLGeocoder()

    var locationString : String!
    var locationCoordinate : CLLocationCoordinate2D!

    var tapRecognizer : UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.hidden             = true
        urlTextField.hidden        = true
        pleaseEnterUrlLabel.hidden = true
        submitButton.hidden        = true

        locationTextField.delegate = self
        urlTextField.delegate      = self

        urlTextField.keyboardType = UIKeyboardType.URL

        findOnMapButton.setTitle("Geocoding...", forState: UIControlState.Disabled)

        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        addKeyboardDismissRecognizer()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardDismissRecognizer()
    }

    func addKeyboardDismissRecognizer() {

        self.view.addGestureRecognizer(tapRecognizer)
    }

    func removeKeyboardDismissRecognizer() {

        self.view.removeGestureRecognizer(tapRecognizer)
    }

    func endAllTextBoxEditing() {
        self.view.endEditing(true)
    }

    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            endAllTextBoxEditing()
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        // If user presses return, this will do the same as
        //  pressing the button for the corresponding text field
        if textField === locationTextField {
            findOnMapButtonTapped(findOnMapButton)
        } else if textField === urlTextField {
            submitButtonTapped(submitButton)
        }

        return true
    }

    func handleUrlSubmission(urlString: String) {

        var mutableUrlString = urlString.lowercaseString

        if (mutableUrlString.rangeOfString("http://") == nil) && (mutableUrlString.rangeOfString("https://") == nil) {
            mutableUrlString = "http://" + urlString
        }

        if let url = NSURL(string: mutableUrlString) {

            println("urlString: " + mutableUrlString)

            let studentInformation = StudentInformation(latLonLocation: self.locationCoordinate,
                                                        firstName: UdacityClient.sharedInstance().userFirstName!,
                                                        lastName:  UdacityClient.sharedInstance().userLastName!,
                                                        mediaURL:  mutableUrlString,
                                                        locationString: self.locationString)

            let udacityUserId = UdacityClient.sharedInstance().userID!

            ParseClient.sharedInstance().postStudentInformation(studentInformation, uniqueKey: udacityUserId) { successfulPost in

                if successfulPost {

                    println("Successfully posted location!")

                    // Dismiss this view (go back to the presenting view controller)
                    //  and refresh the StudentLocation data from Parse (in the presenting view controller)
                    let presentingViewController = self.presentingViewController!
                    self.dismissViewControllerAnimated(true, completion: {
                        ParseClient.handleRefreshInViewController(presentingViewController)
                    })

                } else {
                    WebHelper.displayAlertMessage("Failed to post information to web service.", viewController: self)
                }
            }

        } else {
            WebHelper.displayAlertMessage("URL is invalid. Please enter a valid URL.", viewController: self)
        }
    }

    @IBAction func submitButtonTapped(sender: AnyObject) {

        self.endAllTextBoxEditing()

        if count(urlTextField.text) > 0 {

            handleUrlSubmission(urlTextField.text)

        } else {
            WebHelper.displayAlertMessage("Please enter a URL.", viewController: self)
        }
    }

    func setUpUiElementsForUrlSubmission() {

        locationTextField.hidden        = true
        findOnMapButton.hidden          = true
        whereAreYouStudyingLabel.hidden = true

        mapView.hidden             = false
        urlTextField.hidden        = false
        pleaseEnterUrlLabel.hidden = false
        submitButton.hidden        = false
    }

    func enterMapView() {

        setUpUiElementsForUrlSubmission()

        mapView.setRegion(MKCoordinateRegion(center: self.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = self.locationCoordinate

        mapView.addAnnotation(annotation)
    }

    func handleAddressString(addressString: String) {

        self.findOnMapButton.enabled = false
        self.activityIndicator.startAnimating()

        geocoder.geocodeAddressString(addressString) { (placemarkArray: [AnyObject]!, error: NSError!) -> Void in

            var success = false

            if let error = error {
                println("Geocoder download error: \(error)")
            } else if let placemarkArray = placemarkArray as? [CLPlacemark] {

                let placemark = placemarkArray[0]

                self.locationCoordinate = placemark.location.coordinate

                if let locality = placemark.locality, let adminArea = placemark.administrativeArea {
                    self.locationString = locality + ", " + adminArea
                } else {
                    self.locationString = placemark.name
                }

                println("finished with geocoder")
                println("formatted location string = \(self.locationString)")
                println("lat/lon = (\(self.locationCoordinate.latitude), \(self.locationCoordinate.longitude))")

                self.enterMapView()

                self.activityIndicator.stopAnimating()

                success = true

            } else {
                println("Geocode result is nil")
            }

            if !success {
                self.findOnMapButton.enabled = true
                self.activityIndicator.stopAnimating()
                WebHelper.displayAlertMessage("Error finding location.", viewController: self)
            }
        }
    }

    @IBAction func findOnMapButtonTapped(sender: AnyObject) {

        self.endAllTextBoxEditing()

        if count(locationTextField.text) > 0 {
            handleAddressString(locationTextField.text)
        } else {
            WebHelper.displayAlertMessage("Please enter a location.", viewController: self)
        }
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.endAllTextBoxEditing()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
