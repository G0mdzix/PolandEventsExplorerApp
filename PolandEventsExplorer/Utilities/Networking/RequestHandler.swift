import Foundation

enum RequestHandler {
    static var session = URLSession.shared
    
    static func requestData(for request: URLRequest) async throws -> Data {
        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            
            guard !data.isEmpty else { throw APIError.noData }
            return data
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    private static func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400...499:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw APIError.invalidResponse
        }
    }
}
