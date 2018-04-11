
import UIKit
import SwiftyJSON

protocol APIServiceSharier {
    var sharedAPIService: APIService {get}
}

class APIService: NSObject {
    
    public static let baseURL = "https://your-journey.herokuapp.com/api"
    //public static let accessKey = ""
    
    private let environment: NetworkingEnvironment
    private let dispatcher: NetworkingDispatcher
    
    static func shared() -> APIService {
        return (UIApplication.shared.delegate as! APIServiceSharier).sharedAPIService
    }
    
    override init() {
        environment = NetworkingEnvironment("name", host: APIService.baseURL)
        dispatcher = ConcreateNetworkingDispatcher(environment: environment)
    }
    
    public func login(mail: String, password : String, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = LoginOperation(mail: mail, password: password)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func register(name: String, mail: String, password : String, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = RegisterOperation(name: name, mail: mail, password: password)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
}
