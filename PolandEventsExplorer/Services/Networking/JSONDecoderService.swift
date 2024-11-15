import Foundation

enum JSONDataDecoder {
    static func decode<T: Codable>(data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
