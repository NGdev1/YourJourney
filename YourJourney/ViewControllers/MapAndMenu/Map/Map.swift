//
//  Main.swift
//  YourJourney
//
//  Created by Apple on 06.11.2017.
//  Copyright © 2017 md. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import GoogleMaps
import GooglePlaces

class Map: UIViewController, GMSMapViewDelegate, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var placeDescription: PlaceDescriptionView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var buttonMenu: UIBarButtonItem!
    @IBOutlet weak var heigntOverlayViewConstraint: NSLayoutConstraint!
    
    var cityView : CityView = CityView()
    
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15
    
    var places = [GMSMarker: Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DataManager.removeValue(key: "token")
        //print("token: \(DataManager.getValue(key: "token"))")
        
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
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        heigntOverlayViewConstraint.constant = 0
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 4)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isHidden = true
        mapView.delegate = self
        
        initPlacesDescription()
        startLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func chacgeCity() {
        showAutoCompleteViewController()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        didTap(marker: marker)
        return false
    }
    
    func addMarkerWith(location: CLLocationCoordinate2D, likes: String) -> GMSMarker {
        let position = location
        let marker = GMSMarker(position: position)
        marker.icon = MapPin.drawMapPin(likes)
        marker.map = mapView
        return marker
    }
    
    func setDefaultLocation() {
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
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                
                let city = address.locality
                let country = address.country
                
                guard city != nil else {
                    self.cityView.state = .displayCity
                    self.cityView.changeCityButton!.setTitle("Город не определен", for: .normal)
                    self.showError("Не удалось определить город.")
                    
                    return
                }
                
                self.cityView.state = .displayCity
                self.cityView.changeCityButton!.setTitle(city, for: .normal)
                
                self.loadPlaces(country: country!, city: city!)
            }
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
