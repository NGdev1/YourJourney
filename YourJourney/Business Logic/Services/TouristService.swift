//
//  TouristService.swift
//  YourJourney
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class TouristService {
    
    typealias LoadTouristResult = (tourist: Tourist?, error: Error?)
    
    static func loadTourist(id: Int, places: Bool, completionHandler: @escaping (LoadTouristResult) -> Void) {
        let _ = APIService.shared().tourist(id: id,
                                            places: places,
                                            completionHandler:
            {(responce: (code: Int?, body: JSON?)?, error) in
                
                if error != nil {
                    completionHandler(LoadTouristResult(tourist: nil, error: error))
                    return
                }
                
                let tourist = Tourist()
                
                if responce!.code == 0 {
                    let body = responce!.body!
                    
                    tourist.id = body["id"].int
                    tourist.name = body["name"].string
                    tourist.gender = body["gender"].string
                    tourist.avatar = body["avatar"].string
                    tourist.about = body["about"].string
                    tourist.homeCountry = body["home_country"].string
                    tourist.homeCity = body["home_city"].string
                    
                } else if responce!.code == 3 {
                    completionHandler(LoadTouristResult(tourist: nil, APIErrors.noInfo))
                    return
                } else if responce!.code == 4 {
                    completionHandler(LoadTouristResult(tourist: nil, APIErrors.badRequest))
                    return
                } else {
                    completionHandler(LoadTouristResult(tourist: nil, APIErrors.unknounError))
                    return
                }
                
                completionHandler(LoadTouristResult(tourist: tourist, error: nil))
        })
    }
    
    static func loadUserProfile(places: Bool, completionHandler: @escaping (LoadTouristResult) -> Void) {
        let _ = APIService.shared().userProfile(places: places, completionHandler:
            {(responce: (code: Int?, body: JSON?)?, error) in
                
                if error != nil {
                    completionHandler(LoadTouristResult(tourist: nil, error: error))
                    return
                }
                
                let tourist = Tourist()
                
                if responce!.code == 0 {
                    let body = responce!.body!
                    
                    tourist.id = body["id"].int
                    tourist.name = body["name"].string
                    tourist.gender = body["gender"].string
                    tourist.avatar = body["avatar"].string
                    tourist.email = body["email"].string
                    tourist.about = body["about"].string
                    tourist.homeCountry = body["home_country"].string
                    tourist.homeCity = body["home_city"].string
                    
                    tourist.places = [Int]()
                    for item in body["places"].arrayValue {
                        if let placeId = item.int {
                            tourist.places!.append(placeId)
                        }
                    }
                    
                    tourist.subscribers = [Int]()
                    for item in body["subscribers"].arrayValue {
                        if let subscriber = item.int {
                            tourist.subscribers!.append(subscriber)
                        }
                    }
                    
                    tourist.subscriptions = [Int]()
                    for item in body["subscriptions"].arrayValue {
                        if let subscription = item.int {
                            tourist.subscriptions!.append(subscription)
                        }
                    }
                    
                    tourist.likedPlaces = [Int]()
                    for item in body["liked_places"].arrayValue {
                        if let placeId = item.int {
                            tourist.likedPlaces!.append(placeId)
                        }
                    }
                    
                } else if responce!.code == 3 {
                    completionHandler(LoadTouristResult(tourist: nil, APIErrors.noInfo))
                    return
                } else if responce!.code == 4 {
                    completionHandler(LoadTouristResult(tourist: nil, APIErrors.badRequest))
                    return
                } else {
                    completionHandler(LoadTouristResult(tourist: nil, APIErrors.unknounError))
                    return
                }
                
                completionHandler(LoadTouristResult(tourist: tourist, error: nil))
        })
    }
}
