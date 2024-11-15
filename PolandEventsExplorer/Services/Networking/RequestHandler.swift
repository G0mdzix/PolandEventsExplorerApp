import Foundation

enum RequestHandler {
    static var session = URLSession.shared
    
    static func requestData(for request: URLRequest) async throws -> Data {
        let (data, _) = try await session.data(for: request)
        return data
    }
}
