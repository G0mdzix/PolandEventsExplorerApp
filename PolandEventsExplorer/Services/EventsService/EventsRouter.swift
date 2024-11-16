import Foundation

enum EventsRouter: RouterProtocol {
    case getEventDetails(id: String)
    case getEventSearch(settings: EventFetchSettings)
    
    var scheme: String {
        switch self {
        case .getEventSearch, .getEventDetails:
            "https"
        }
    }
    
    var host: String {
        switch self {
        case .getEventSearch, .getEventDetails:
            "app.ticketmaster.com"
        }
    }
    
    var path: String {
        switch self {
        case .getEventSearch:
            "/discovery/v2/events.json"
        case .getEventDetails(let id):
            "/discovery/v2/events/\(id).json"
        }
    }
    
    var method: String {
        switch self {
        case .getEventSearch, .getEventDetails:
            "GET"
        }
    }
    
    var query: [URLQueryItem] {
        switch self {
        case .getEventSearch(let settings):
            EventsRouter.defaultsURLQueryItems + [
                URLQueryItem(name: "size", value: settings.pageSize.rawValue),
                URLQueryItem(name: "page", value: String(settings.page)),
            ]
        case .getEventDetails:
            EventsRouter.defaultsURLQueryItems
        }
      }
}

extension EventsRouter {
    private static var defaultsURLQueryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "apikey", value: AppSecrets.apiKey),
            URLQueryItem(name: "locale", value: "*"),
            URLQueryItem(name: "countryCode", value: "PL"),
        ]
    }
}
