//
//  MapPlaces.swift
//  YourJourney
//
//  Created by Apple on 25.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import GoogleMaps
import SDWebImage

extension Map {
    
    func initPlacesDescription() {
        //GestureRecognizer
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeOverlayView))
        swipeDown.direction = .down
        placeDescription.addGestureRecognizer(swipeDown)
        placeDescription.hideButton.addTarget(self, action: #selector(Map.hidePlaceDescription), for: .touchUpInside)
        placeDescription.buttonPlaceName.addTarget(self, action: #selector(Map.showPlaceFullInfo), for: .touchUpInside)
        placeDescription.buttonShowAuthor.addTarget(self, action: #selector(Map.showAuthor), for: .touchUpInside)
    }
    
    @objc func showPlaceFullInfo() {
        guard let place = placeDescription.place else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Place", bundle: nil)
        let nextVc = storyboard.instantiateInitialViewController() as! PlaceViewController
        nextVc.place = place
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @objc func showAuthor() {
        guard let place = placeDescription.place else {
            return
        }
        
        let storyboard = UIStoryboard(name: "TouristProfile", bundle: nil)
        let nextVc = storyboard.instantiateInitialViewController() as! TouristProfile
        let tourist = Tourist()
        tourist.id = place.ownerId
        nextVc.tourist = tourist
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    @objc func swipeOverlayView(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.down:
                hidePlaceDescription()
            default:
                break
            }
        }
    }
    
    @objc func hidePlaceDescription() {
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
    
    func showPlaceDescription(height: CGFloat) {
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
    
    func didTap(marker: GMSMarker) {
        guard let place = places[marker] else {
            showError("Не удалозь загрузить описание места.")
            return
        }
        
        let height = placeDescription.setAppearance(with: place)
        
        showPlaceDescription(height: height)
    }
    
    func loadPlaces(country: String, city: String){
        self.mapView.startShowingActivityIndicator()
        
        PlaceService.loadPlaces(country: country, city: city) {
            result in
            
            self.mapView.stopShowingActivityIndicator()
            
            if result.error != nil {
                self.showError(result.error!.localizedDescription)
                return
            }
            
            guard result.places != nil else {
                return
            }
            
            for place in result.places! {
                
                let location = CLLocationCoordinate2D(latitude: place.latitude!,
                                                      longitude: place.longtitude!)
                
                let marker = self.addMarkerWith(location: location,
                                                likes: String(place.likes!))
                
                self.places[marker] = place
            }
        }
    }
}
