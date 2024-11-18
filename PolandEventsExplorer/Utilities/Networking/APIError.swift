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
            StringHandler.APIErrorDescription.invalidResponse
        case .serverError(let statusCode):
            StringHandler.APIErrorDescription.serverError + "\(statusCode)"
        case .noData:
            StringHandler.APIErrorDescription.noData
        case .decodingError:
            StringHandler.APIErrorDescription.decodingError
        case .networkError(let error):
            StringHandler.APIErrorDescription.networkError + "\(error.localizedDescription)"
        }
    }
}
