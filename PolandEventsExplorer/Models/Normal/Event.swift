import Foundation

struct Event: Codable {
    let name: String
    let type: String
    let id: String
    let images: [EventImage]
    let timezone: String?
    let venuesResponse: VenuesResponse?
    let dates: EventDates?
    let seatmap: Seatmap?
    let priceRanges: [PriceRange]?
}

extension Event {
    enum CodingKeys: String, CodingKey {
        case name, type, id, images, timezone, venuesResponse = "_embedded", dates, seatmap, priceRanges
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
        images = try container.decode([EventImage].self, forKey: .images)
        timezone = try? container.decode(String.self, forKey: .timezone)
        venuesResponse = try? container.decode(VenuesResponse.self, forKey: .venuesResponse)
        dates = try? container.decode(EventDates.self, forKey: .dates)
        seatmap = try? container.decode(Seatmap.self, forKey: .seatmap)
        priceRanges = try? container.decode([PriceRange].self, forKey: .priceRanges)
    }
}
