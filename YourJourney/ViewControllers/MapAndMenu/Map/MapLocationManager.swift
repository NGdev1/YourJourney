//
//  MapLocationManager.swift
//  YourJourney
//
//  Created by Apple on 25.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import GoogleMaps

extension Map: CLLocationManagerDelegate {
    
    func startLocationManager() {
        locationManager.delegate = self
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            setDefaultLocation()
            mapView.isHidden = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations.last!
        locationManager.stopUpdatingLocation()
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                              longitude: userLocation.coordinate.longitude)
        
        if cityView.state == .loading {
            reverseGeocodeCoordinate(coordinate: location)
        }
        
        centerMapOnLocation(location)
        mapView.isHidden = false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("NotDetermined")
            setDefaultLocation()
        case .restricted:
            print("Restricted")
            setDefaultLocation()
        case .denied:
            print("Denied")
            setDefaultLocation()
        case .authorizedAlways:
            print("AuthorizedAlways")
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
        }
    }
}
