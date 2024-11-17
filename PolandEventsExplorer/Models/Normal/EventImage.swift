import Foundation
import SwiftUI

struct EventImage: Codable {
    let url: String
    
    var image: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .failure:
                Image(systemName: SFSymbols.questionmark)
                    .font(.largeTitle)
            case .success(let image):
                image
                    .resizable()
            default:
                ProgressView()
            }
        }
    }
}

extension EventImage {
    enum CodingKeys: String, CodingKey {
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
    }
}
