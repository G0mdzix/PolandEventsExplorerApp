import Foundation

struct EventResponse: Codable {
    let embedded: EmbeddedEvents
    let page: Page
}

extension EventResponse {
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded", page
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        embedded = try container.decode(EmbeddedEvents.self, forKey: .embedded)
        page = try container.decode(Page.self, forKey: .page)
    }
}
