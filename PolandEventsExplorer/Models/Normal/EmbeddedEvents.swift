import Foundation

struct EmbeddedEvents: Codable {
    let events: [Event]
}

extension EmbeddedEvents {
    enum CodingKeys: String, CodingKey {
        case events
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        events = try container.decode([Event].self, forKey: .events)
    }
}
