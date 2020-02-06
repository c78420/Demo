//
//  MKMap.swift
//  Demo
//
//  Created by 黃崇漢 on 2018/7/17.
//  Copyright © 2018年 Tony Huang (黃崇漢). All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MKMap: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let latitude: CLLocationDegrees = 48.858547
//        let longitude: CLLocationDegrees = 2.294524
//
//        let location: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.activityType = .automotiveNavigation
        self.locationManager?.startUpdatingLocation()
        if let coordinate = self.locationManager?.location?.coordinate {
            let xScale: CLLocationDegrees = 0.01
            let yScale: CLLocationDegrees = 0.01
            
            let span: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: yScale, longitudeDelta: xScale)
            
            let region: MKCoordinateRegion = MKCoordinateRegion.init(center: coordinate, span: span)
            
            self.map.setRegion(region, animated: true)
        }
        
        self.map.userTrackingMode = .followWithHeading
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.locationManager?.stopUpdatingLocation()
        super.viewDidDisappear(animated)
    }
    
    @IBAction func addMeAnnotation(_ sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: self.map)
        let touchCoordinate: CLLocationCoordinate2D = map.convert(touchPoint, toCoordinateFrom: self.map)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchCoordinate
        annotation.title = "New Place"
        annotation.subtitle = "One day I wanna be here"
        
        self.map.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("_________________________________")
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
    }
}
