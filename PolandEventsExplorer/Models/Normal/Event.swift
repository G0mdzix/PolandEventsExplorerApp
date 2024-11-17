import Foundation

struct Event: Codable {
    let name: String
    let type: String
    let id: String
    let images: [EventImage]
    let venuesResponse: VenuesResponse?
    let dates: EventDates?
    let seatmap: Seatmap?
    let priceRanges: [PriceRange]?
    let classifications: [Classification]?
    
    var originalImages: [EventImage] {
        images.reduce(into: [EventImage]()) { filteredImages, image in
            if !filteredImages.contains(where: { UniqueURLHelper.compareStrings(image.url, $0.url) < 0.4 }) {
                filteredImages.append(image)
            }
        }
    }
}

extension Event {
    enum CodingKeys: String, CodingKey {
        case name
        case type
        case id
        case images
        case venuesResponse = "_embedded"
        case dates
        case seatmap
        case priceRanges
        case classifications
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
        images = try container.decode([EventImage].self, forKey: .images)
        venuesResponse = try? container.decode(VenuesResponse.self, forKey: .venuesResponse)
        dates = try? container.decode(EventDates.self, forKey: .dates)
        seatmap = try? container.decode(Seatmap.self, forKey: .seatmap)
        priceRanges = try? container.decode([PriceRange].self, forKey: .priceRanges)
        classifications = try? container.decode([Classification].self, forKey: .classifications)
    }
}
