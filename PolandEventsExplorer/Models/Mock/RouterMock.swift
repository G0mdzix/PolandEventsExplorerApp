import Foundation

enum RouterMock: RouterProtocol {
    case getSuccesfulEventMock
    case getFailedEventMock
    
    var scheme: String {
        "https"
    }
    
    var host: String {
        switch self {
        case .getSuccesfulEventMock:
            "app.ticketmaster.com"
        case .getFailedEventMock:
            "xyz"
        }
    }
    
    var path: String {
        switch self {
        case .getSuccesfulEventMock:
            "/discovery/v2/events.json"
        case .getFailedEventMock:
            "z.z.z"
        }
    }
    
    var method: String {
        "GET"
    }
    
    var query: [URLQueryItem] {
        [
            URLQueryItem(name: "countryCode", value: "PL"),
        ]
    }

}
