//
//  UserProfileOperation.swift
//  YourJourney
//
//  Created by Apple on 23.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserProfileOperation: NetworkingOperation {
    
    var request: Request
    
    init(places: Bool) {
        request = Requests.userProfile(places: places)
    }
    
    typealias Result = (code: Int?, body: JSON?)?
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping ((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        
        return dispatcher.execute(request: request, completionHandler: { (data, response, error) in
            print("UserProfileOperation \(String(describing: response?.statusCode))")
            if let err = error {
                completionHandler(nil, err)
                return
            } else {
                if response?.statusCode != 200 || data == nil {
                    completionHandler(nil, APIErrors.unknounError)
                } else {
                    let json = JSON(data: data!)
                    
                    let body = json["body"]
                    let code = json["code"].intValue
                    
                    completionHandler((code, body), nil)
                }
            }
        })
    }
}

