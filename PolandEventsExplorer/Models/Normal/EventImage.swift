import Foundation

struct EventImage: Codable {
    let ratio: String?
    let url: String
    let width: Int
    let height: Int
    let fallback: Bool
}

extension EventImage {
    enum CodingKeys: String, CodingKey {
        case ratio, url, width, height, fallback
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        ratio = try? container.decode(String.self, forKey: .ratio)
        url = try container.decode(String.self, forKey: .url)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        fallback = try container.decode(Bool.self, forKey: .fallback)
    }
}
