//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Shawn Spencer on 7/14/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        addMapAnnotations()
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

    @IBAction func refreshButtonTapped(sender: AnyObject) {

        ParseClient.sharedInstance().getStudentLocations() { success in

            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.addMapAnnotations()
                })
            } else {
                println("Get student locations failed")
            }
        }
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
