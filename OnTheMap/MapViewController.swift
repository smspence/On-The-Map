//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/14/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, StudentLocationUpdateListener {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewNavBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        addRightBarButtonItems()

        ParseClient.sharedInstance().addLocationDataListener(self)

        addMapAnnotations()
    }

    func addRightBarButtonItems() {
        var navItem = mapViewNavBar.items[0] as! UINavigationItem

        var buttons = [UIBarButtonItem]()

        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshButtonTapped:")
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addLocationButtonTapped:")

        buttons.append(refreshButton)
        buttons.append(addLocationButton)
        navItem.setRightBarButtonItems(buttons, animated: false)
    }

    func studentLocationDataUpdated() {
        println("MapViewController studentLocationDataUpdated() called")
        self.addMapAnnotations()
    }

    func addMapAnnotations() {

        var annotations = [MKPointAnnotation]()
        self.mapView.removeAnnotations(self.mapView.annotations)

        for entry in ParseClient.sharedInstance().locationList {
            var annotation = MKPointAnnotation()
            annotation.coordinate = entry.latLonLocation
            annotation.title = "\(entry.firstName) \(entry.lastName)"
            annotation.subtitle = entry.mediaURL

            annotations.append(annotation)
        }

        self.mapView.addAnnotations(annotations)
    }

    func refreshButtonTapped(sender: AnyObject) {

        ParseClient.handleRefreshInViewController(self)
    }

    @IBAction func logoutButtonTapped(sender: AnyObject) {
        println("logoutButtonTapped")
    }

    func addLocationButtonTapped(sender: AnyObject) {

        println("addLocationButtonTapped")
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }

    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == annotationView.rightCalloutAccessoryView {
            if let urlString = annotationView.annotation.subtitle where urlString != nil {
                WebHelper.visitUrlString(urlString, fromViewController: self)
            } else {
                WebHelper.displayInvalidUrlAlert(self)
            }
        }
    }

}
