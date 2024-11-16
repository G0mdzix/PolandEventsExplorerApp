import Foundation

protocol RouterProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var query: [URLQueryItem] { get }
}
