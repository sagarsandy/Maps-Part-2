//
//  ViewController.swift
//  Maps Part 2
//
//  Created by Sagar Sandy on 27/11/18.
//  Copyright © 2018 Sagar Sandy. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // User interface elements
    @IBOutlet weak var mapViewOutlet: MKMapView!
    
    // User defined variables
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewOutlet.delegate = self
        
        
        // Initializing location manager delegate
        locationManager.delegate = self
        
        // Setting up location manager properties
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        
        addPointOfInterest()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    // MARK: Add button pressed on navigation bar action
    @IBAction func addButtonPressed(_ sender: Any) {
        
        
        let alertVC = UIAlertController(title: "Enter Address", message: nil, preferredStyle: .alert)
        
        alertVC.addTextField { (textField) in }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            if let textField = alertVC.textFields?.first {
                
                self.reverseGeoCode(address : textField.text!)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in }
        
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    
    // MARK: Reverse geo coding, fetching lat and long based on entered address
    func reverseGeoCode(address : String) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placeMarks, error) in
            
            if let error = error {
                print(error)
                
                return
            }
            
            guard let placemarks = placeMarks,
                let placemark = placemarks.first else {
                    return
            }
            
            self.addAnnoatationToMapBasedOnPlacemark(placemark: placemark)
        }
    }
    
    // MARK: Add annoation to the mapview based on fetched placemarks
    func addAnnoatationToMapBasedOnPlacemark(placemark : CLPlacemark) {
        
        if let coordinate = placemark.location?.coordinate {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapViewOutlet.addAnnotation(annotation)
            
        }
        
    }
    
    // MARK: Add point of intereset where we wanna draw the circle
    func addPointOfInterest() {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 18.923071, longitude: 72.834183)
        mapViewOutlet.addAnnotation(annotation)
        
        // Creating a region, so that we can notify the user, when he enteres that region(This region lat and long are defined in above annoation).
        let region = CLCircularRegion(center: annotation.coordinate, radius: 500, identifier: "Gateway Of India")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        // Monitoring the location region, delegate methods automatically fired once user entered this region
        locationManager.startMonitoring(for: region)
        
        mapViewOutlet.addOverlay(MKCircle(center: annotation.coordinate, radius: 500))
    }
    
    
    
    // MARK: Delegate method for entering a region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        
        print("You've entered The Gateway of india")
        
        // Note: This method will take 2 to 3 minutes as per the apple doc's to fire, once the user entered this location
        
    }
    
    // MARK: Delegate method for exit a region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        
        print("You've just visited The gate way of India")
        
        // Note: This method will take 2 to 3 minutes as per the apple doc's to fire, once the user exit this location
    }
    
    
    // MARK: Delegate method for rendering overlay(Circle region) at our point of interest
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle {
            
            let circleRender = MKCircleRenderer(circle: overlay as! MKCircle)
            circleRender.lineWidth = 2.0
            circleRender.strokeColor = UIColor.cyan
            circleRender.fillColor = UIColor.red
            circleRender.alpha = 0.5
            
            return circleRender
        }
        
        return MKOverlayRenderer()
    }
    
}

