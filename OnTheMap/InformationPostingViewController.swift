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

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var informationPostingNavBar: UINavigationBar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findOnMapButton: UIButton!

    @IBOutlet weak var mapView: MKMapView!

    let geocoder = CLGeocoder()

    var locationString : String!
    var locationCoordinate : CLLocationCoordinate2D!

    var tapRecognizer : UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.hidden = true

        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //subscribeToKeyboardNotifications()
        addKeyboardDismissRecognizer()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        //unsubscribeToKeyboardNotifications()
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

    func enableMapView() {

        mapView.hidden = false

        mapView.setRegion(MKCoordinateRegion(center: self.locationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = self.locationCoordinate

        mapView.addAnnotation(annotation)
    }

    func handleAddressString(addressString: String) {

        geocoder.geocodeAddressString(addressString) { (placemarkArray: [AnyObject]!, error: NSError!) -> Void in

            if let error = error {
                println("Geocoder error: \(error)")
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

                self.enableMapView()

            } else {
                println("Geocode result is nil")
            }

        }
    }

    @IBAction func findOnMapButtonTapped(sender: AnyObject) {

        if count(locationTextField.text) > 0 {
            handleAddressString(locationTextField.text)
        } else {
            println("Please enter a location")
        }
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.endAllTextBoxEditing()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
