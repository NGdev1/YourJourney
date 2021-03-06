//
//  MapCityNameLoading.swift
//  YourJourney
//
//  Created by Apple on 19.12.2017.
//  Copyright © 2017 md. All rights reserved.
//

import Foundation
import GooglePlaces

extension Map : GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        cityView.changeCityButton!.setTitle(place.name, for: .normal)
        
        centerMapOnLocation(place.coordinate)
        
        self.cityView.state = .displayCity
        
        var country: String!
        var city: String!
        
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                if field.type == kGMSPlaceTypeCountry {
                    country = field.name
                } else if field.type == kGMSPlaceTypeLocality {
                    city = field.name
                }
                
                print("Type: \(field.type), Name: \(field.name)")
            }
        }
        
        self.loadPlaces(country: country, city: city)
        
        UIApplication.shared.statusBarStyle = .lightContent
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.cityView.state = .displayCity
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.statusBarStyle = .lightContent
        self.cityView.state = .displayCity
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func showAutoCompleteViewController(){
        let autocompleteController = GMSAutocompleteViewController()
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        autocompleteController.delegate = self
        
        UIApplication.shared.statusBarStyle = .default
        cityView.state = .changingCity
        
        present(autocompleteController, animated: true, completion: nil)
    }
}
