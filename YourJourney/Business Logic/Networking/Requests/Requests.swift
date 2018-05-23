
import Foundation

public enum Requests: Request {
    case login(mail: String, password: String)
    case updateToken()
    case registration(name: String, mail: String, password: String)
    case places(country: String, city: String)
    case topPlaces(country: String, city: String, topType: String)
    case place(id: String)
    case tourist(id: String, places: Bool)
    case comments(placeId: String, offset: String, limit: String)
    case writeComment(placeId: String, text: String)
    case placeReport(id: String)
    case userProfile(places: Bool)
    
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
            return "/places/" + id
        case .comments(let id, _, _):
            return "/places/" + id + "/comments"
        case .writeComment(let placeId, _):
            return "/places/" + placeId + "/comments"
        case .tourist(let id, _):
            return "/tourists/" + id
        case .placeReport(let id):
            return "/places/" + id + "/report"
        case .userProfile:
            return "/profile"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .login, .updateToken, .registration, .placeReport, .writeComment:
            return .post
        case .places, .topPlaces, .place, .tourist, .comments, .userProfile:
            return .get
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .login(let mail, let password):
            return .body(["email" : mail, "password": password])
        case .updateToken:
            return .url(["refresh_token" : DataManager.getValue(key: "refresh_token")!])
        case .registration(let name, let mail, let password):
            return .body(["name" : name, "email" : mail, "password": password])
        case .places(let country, let city):
            return .url(["country" : country, "city" : city])
        case .topPlaces(let country, let city, let topType):
            return .url(["country" : country, "city" : city, "top_type": topType])
        case .place:
            return .url([:])
        case .placeReport:
            return .url([:])
        case .tourist(_, let places):
            let placesValue = places ? "0" : "1"
            return .url(["places": placesValue])
        case .comments(_, let offset, let limit):
            return .url(["offset": offset, "limit": limit])
        case .writeComment(_, let text):
            return .body(["text" : text])
        case .userProfile(let places):
            let placesValue = places ? "0" : "1"
            return .url(["places": placesValue])
        }
    }
    
    public var headers: [String : Any]? {
        switch self {
        case .login, .updateToken, .registration, .tourist, .comments:
            return ["content-type"  : "application/json"]
        case .topPlaces, .places, .place, .placeReport, .writeComment, .userProfile:
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
        case .login,
             .updateToken,
             .registration,
             .places,
             .topPlaces,
             .place,
             .tourist,
             .placeReport,
             .comments,
             .writeComment,
             .userProfile:
            return .JSON
        }
    }
}
