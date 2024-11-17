import Foundation
import SwiftUI

struct EventImage: Codable {
    let ratio: String?
    let url: String
    let width: Int
    let height: Int
    let fallback: Bool
    
    var image: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .failure:
                Image(systemName: "questionmark.square.fill")
                    .font(.largeTitle)
            case .success(let image):
                image
                    .resizable()
            default:
                ProgressView()
            }
        }
        .frame(width: 256, height: 256)
        .clipShape(.rect(cornerRadius: 25))
    }
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
