
import UIKit
import SwiftyJSON

class RegisterOperation: NetworkingOperation {
    
    var request: Request
    
    init(name: String, mail : String, password: String) {
        request = Requests.registration(name: name, mail: mail, password: password)
    }
    
    typealias Result = (code: Int?, body: JSON?)?
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping ((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        
        return dispatcher.execute(request: request, completionHandler: { (data, response, error) in
            print("RegisterOperation \(String(describing: response?.statusCode))")
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

