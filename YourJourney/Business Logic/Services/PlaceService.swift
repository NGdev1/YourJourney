//
//  PlaceService.swift
//  YourJourney
//
//  Created by Apple on 18.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class PlaceService {
    
    typealias LoadPlacesResult = (places: [Place]?, error: Error?)
    typealias LoadPlaceResult = (place: Place?, error: Error?)
    typealias PlaceServiceBaseResult = (success: Bool?, error: Error?)
    
    static func loadPlaces(country: String, city: String, completionHandler: @escaping (LoadPlacesResult) -> Void) {
        let _ = APIService.shared().places(country: country,
                                           city: city,
                                           completionHandler:
            {(responce: (code: Int?, body: JSON?)?, error) in
                
                if error != nil {
                    completionHandler(LoadPlacesResult(places: nil, error: error))
                    return
                }
                
                var places = [Place]()
                
                if responce!.code == 0 {
                    let placesJson = responce!.body!["places"].arrayValue
                    
                    for placeJson in placesJson {
                        let place = Place()
                        
                        place.latitude = placeJson["lat"].doubleValue
                        place.longtitude = placeJson["lon"].doubleValue
                        place.likes = placeJson["likes"].intValue
                        place.title = placeJson["title"].string
                        place.id = placeJson["id"].intValue
                        place.comments = placeJson["comments"].intValue
                        place.ownerId = placeJson["owner_id"].intValue
                        place.isPrivate = placeJson["private"].boolValue
                        place.logo = placeJson["logo"].string
                        place.isLiked = placeJson["liked"].boolValue
                        
                        places.append(place)
                    }
                } else if responce!.code == 3 {
                    completionHandler(LoadPlacesResult(places: nil, APIErrors.noInfo))
                    return
                } else if responce!.code == 4 {
                    completionHandler(LoadPlacesResult(places: nil, APIErrors.badRequest))
                    return
                } else {
                    completionHandler(LoadPlacesResult(places: nil, APIErrors.unknounError))
                    return
                }
                
                completionHandler(LoadPlacesResult(places: places, error: nil))
        })
    }
    
    static func loadPlace(id: Int, completionHandler: @escaping (LoadPlaceResult) -> Void) {
        let _ = APIService.shared().place(id: id,
                                           completionHandler:
            {(responce: (code: Int?, body: JSON?)?, error) in
                
                if error != nil {
                    completionHandler(LoadPlaceResult(place: nil, error: error))
                    return
                }
                
                let place = Place()
                
                if responce!.code == 0 {
                    let placeJson = responce!.body!
                    
                    place.latitude = placeJson["lat"].double
                    place.longtitude = placeJson["lon"].double
                    place.likes = placeJson["likes"].int
                    place.title = placeJson["title"].string
                    place.id = placeJson["id"].int
                    place.comments = placeJson["comments"].int
                    place.ownerId = placeJson["owner_id"].int
                    place.isPrivate = placeJson["private"].bool
                    place.isLiked = placeJson["liked"].bool
                    place.about = placeJson["description"].string
                    
                    var photos = [String]()
                    
                    for item in placeJson["photos"].arrayValue {
                        if let photo = item.string {
                            photos.append(photo)
                        }
                    }
                    
                    place.photos = photos
                    
                } else if responce!.code == 3 {
                    completionHandler(LoadPlaceResult(place: nil, APIErrors.noInfo))
                    return
                } else if responce!.code == 4 {
                    completionHandler(LoadPlaceResult(place: nil, APIErrors.badRequest))
                    return
                } else {
                    completionHandler(LoadPlaceResult(place: nil, APIErrors.unknounError))
                    return
                }
                
                completionHandler(LoadPlaceResult(place: place, error: nil))
        })
    }
    
    static func loadTopPlaces(country: String, city: String, topType: TopPlacesType, completionHandler: @escaping (LoadPlacesResult) -> Void) {
        let _ = APIService.shared().topPlaces(country: country,
                                           city: city,
                                           topType: topType,
                                           completionHandler:
            {(responce: (code: Int?, body: JSON?)?, error) in
                
                if error != nil {
                    completionHandler(LoadPlacesResult(places: nil, error: error))
                    return
                }
                
                var places = [Place]()
                
                if responce!.code == 0 {
                    let placesJson = responce!.body!["places"].arrayValue
                    
                    for placeJson in placesJson {
                        let place = Place()
                        
                        place.latitude = placeJson["lat"].double
                        place.longtitude = placeJson["lon"].double
                        place.likes = placeJson["likes"].int
                        place.title = placeJson["title"].string
                        place.id = placeJson["id"].int
                        place.comments = placeJson["comments"].int
                        place.ownerId = placeJson["owner_id"].int
                        place.isPrivate = placeJson["private"].bool
                        place.isLiked = placeJson["liked"].bool
                        place.logo = placeJson["logo"].string
                        place.about = placeJson["description"].string
                        
                        places.append(place)
                    }
                } else if responce!.code == 3 {
                    completionHandler(LoadPlacesResult(places: nil, APIErrors.noInfo))
                    return
                } else if responce!.code == 4 {
                    completionHandler(LoadPlacesResult(places: nil, APIErrors.badRequest))
                    return
                } else {
                    completionHandler(LoadPlacesResult(places: nil, APIErrors.unknounError))
                    return
                }
                
                completionHandler(LoadPlacesResult(places: places, error: nil))
        })
    }
    
    static func placeReport(id: Int, completionHandler: @escaping (PlaceServiceBaseResult) -> Void) {
        let _ = APIService.shared().place(id: id,
                                          completionHandler:
            {(responce: (code: Int?, body: JSON?)?, error) in
                
                if error != nil {
                    completionHandler(PlaceServiceBaseResult(success: nil, error: error))
                    return
                }
                
                var success = false
                
                if responce!.code == 0 {
                    
                    success = true
                    
                } else if responce!.code == 3 {
                    completionHandler(PlaceServiceBaseResult(success: nil, APIErrors.noInfo))
                    return
                } else if responce!.code == 4 {
                    completionHandler(PlaceServiceBaseResult(success: nil, APIErrors.badRequest))
                    return
                } else {
                    completionHandler(PlaceServiceBaseResult(success: nil, APIErrors.unknounError))
                    return
                }
                
                completionHandler(PlaceServiceBaseResult(success: success, error: nil))
        })
    }
}
