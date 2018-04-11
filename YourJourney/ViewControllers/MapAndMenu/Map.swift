//
//  Main.swift
//  YourJourney
//
//  Created by Apple on 06.11.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class Map: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    @IBOutlet weak var placeDescription: PlaceDescriptionView!
    @IBOutlet weak var heigntOverlayViewConstraint: NSLayoutConstraint!
    
    var cityView : CityView = CityView()
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            //menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchDown)
            self.revealViewController().delegate = self
            buttonMenu.target = self.revealViewController()
            buttonMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            //self.mapView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationItem.titleView = cityView
        self.cityView.changeCityButton!.addTarget(self, action: #selector(self.chacgeCity), for: .touchUpInside)
        cityView.state = .loading
        
        locationManager.delegate = self
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        heigntOverlayViewConstraint.constant = 0
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 4)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isHidden = true
        mapView.delegate = self
        
        //GestureRecognizer
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeOverlayView))
        swipeDown.direction = .down
        placeDescription.addGestureRecognizer(swipeDown)
        placeDescription.hideButton.addTarget(self, action: #selector(Map.hidePlaceDescription), for: .touchUpInside)
        placeDescription.buttonPlaceName.addTarget(self, action: #selector(Map.showPlace), for: .touchUpInside)
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            setDefaultLocation()
            mapView.isHidden = false
        }
        
        addMarkerWith(location: CLLocationCoordinate2D(latitude: 55.802182,
                                                       longitude: 49.105328),
                      likes: "3")
        addMarkerWith(location: CLLocationCoordinate2D(latitude: 55.821292,
                                                       longitude: 49.127518),
                      likes: "23")
        addMarkerWith(location: CLLocationCoordinate2D(latitude: 55.841292,
                                                       longitude: 49.117518),
                      likes: "321")
    }
    
    @objc func showPlace(){
        let storyboard = UIStoryboard(name: "Place", bundle: nil)
        let nextVc = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(nextVc!, animated: true)
    }
    
    @objc func chacgeCity(){
        showAutoCompleteViewController()
    }
    
    @objc func swipeOverlayView(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.up:
                changePlaceDescriptionViewState(isHide: false)
            case UISwipeGestureRecognizerDirection.down:
                changePlaceDescriptionViewState(isHide: true)
            default:
                break
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        changePlaceDescriptionViewState(isHide: false)
        return false
    }
    
    func changePlaceDescriptionViewState(isHide: Bool){
        if isHide {
            hidePlaceDescription()
        } else {
            showPlaceDescription()
        }
    }
    
    @objc func hidePlaceDescription(){
        let height: CGFloat = 0
        heigntOverlayViewConstraint.constant = height
        
        self.mapView.padding = UIEdgeInsets(
            top: self.navigationController?.navigationBar.bounds.height ?? 0 + 50,
            left: 0.0,
            bottom: height + 72,
            right: 0
        )
        
        self.placeDescription.alpha = 1.0
        UIView.animate(withDuration: 0.3) {
            self.placeDescription.alpha = 0.0
            self.placeDescription.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.layoutIfNeeded()
        }
    }
    
    func showPlaceDescription(){
        let height: CGFloat = 197
        heigntOverlayViewConstraint.constant = height
        
        self.mapView.padding = UIEdgeInsets(
            top: self.navigationController?.navigationBar.bounds.height ?? 0 + 50,
            left: 0.0,
            bottom: height + 72,
            right: 0
        )
        
        self.placeDescription.alpha = 0.0
        self.placeDescription.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.placeDescription.alpha = 1.0
            self.placeDescription.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }
    }
    
    func addMarkerWith(location: CLLocationCoordinate2D, likes: String){
        let position = location
        let marker = GMSMarker(position: position)
        marker.icon = MapPin.drawMapPin(likes)
        marker.map = mapView
    }
    
    func setDefaultLocation(){
        centerMapOnLocation(CLLocationCoordinate2D(latitude: 55.802182,
                                                   longitude: 49.105328))
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if position == .left {
            UIApplication.shared.statusBarStyle = .lightContent
        } else {
            UIApplication.shared.statusBarStyle = .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
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
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                let city = address.locality
                
                self.cityView.state = .displayCity
                self.cityView.changeCityButton!.setTitle(city, for: .normal)
                
                self.mapView.startShowingActivityIndicator()
            }
        }
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
    
    func centerMapOnLocation(_ location: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude,
                                              longitude: location.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
}
