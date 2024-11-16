import Foundation

struct EventResponse: Codable {
    let embedded: EmbeddedEvents
}

extension EventResponse {
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        embedded = try container.decode(EmbeddedEvents.self, forKey: .embedded)
    }
}
