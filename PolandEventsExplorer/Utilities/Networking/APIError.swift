import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case serverError(statusCode: Int)
    case noData
    case decodingError
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "Invalid response from the server."
        case .serverError(let statusCode):
            "Server returned an error with status code \n\(statusCode)."
        case .noData:
            "No data was received from the server."
        case .decodingError:
            "Failed to decode the data."
        case .networkError(let error):
            "Network error occurred: \n\(error.localizedDescription)"
        }
    }
}
