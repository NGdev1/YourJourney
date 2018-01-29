
import Foundation

public enum Requests: Request {
    case login(mail: String, password: String)
    case updateToken()
    case registration(name: String, mail: String, password: String)
    case places(country: String, city: String)
    case topPlaces(country: String, city: String, topType: String)
    case place(id: String)
    
    public var path: String {
        switch self {
        case .login:
            return "/login"
        case .updateToken:
            return "/token"
        case .registration:
            return "/registration"
        case .places, .topPlaces:
            return "/places"
        case .place(let id):
            return "/place/" + id
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .login, .updateToken, .registration:
            return .post
        case .places, .topPlaces, .place:
            return .get
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .login(let mail, let password):
            return .body(["email" : mail, "password": password])
        case .updateToken:
            return .body(["refresh_token" : DataManager.getValue(key: "refresh_token")!])
        case .registration(let name, let mail, let password):
            return .body(["name" : name, "email" : mail, "password": password])
        case .places(let country, let city):
            return .url(["country" : country, "city" : city])
        case .topPlaces(let country, let city, let topType):
            return .url(["country" : country, "city" : city, "top_type": topType])
        case .place:
            return .url([:])
        }
    }
    
    public var headers: [String : Any]? {
        switch self {
        case .login, .updateToken, .registration:
            return ["content-type"  : "application/json"]
        case .topPlaces, .places, .place:
            if let token = DataManager.getValue(key: "token"){
                return ["content-type"  : "application/json",
                        "token" : token]
            } else {
                return ["content-type"  : "application/json"]
            }
        }
    }
    
    public var dataType: DataType {
        switch self {
        case .login, .updateToken, .registration, .places, .topPlaces, .place:
            return .JSON
        }
    }
}
