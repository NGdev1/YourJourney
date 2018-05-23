
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
    
    public func updateToken(completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = UpdateTokenOperation()
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func topPlaces(country: String, city: String, topType: TopPlacesType, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = TopPlacesOperation(country: country, city: city, topType: topType)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func places(country: String, city: String, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = PlacesOperation(country: country, city: city)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func place(id: Int, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = PlaceOperation(id: id)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func placeReport(id: Int, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = PlaceReportOperation(placeId: id)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func tourist(id: Int, places: Bool, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = TouristOperation(id: id, places: places)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func comments(placeId: Int, offset: Int, limit: Int, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = CommentsOperation(placeId: placeId, offset: offset, limit: offset)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func writeComment(placeId: Int, text: String, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = WriteCommentOperation(placeId: placeId, text: text)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
    
    public func userProfile(places: Bool, completionHandler: @escaping((code: Int?, body: JSON?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = UserProfileOperation(places: places)
        return operation.execute(in: dispatcher, completionHandler: completionHandler)
    }
}
