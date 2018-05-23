//
//  PlaceOperation.swift
//  YourJourney
//
//  Created by Apple on 16.05.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlaceOperation: NetworkingOperation {
    
    var request: Request
    
    init(id: Int) {
        request = Requests.place(id: String(id))
    }
    
    typealias Result = (code: Int?, body: JSON?)?
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping ((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        
        return dispatcher.execute(request: request, completionHandler: { (data, response, error) in
            print("PlaceOperation \(String(describing: response?.statusCode))")
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


