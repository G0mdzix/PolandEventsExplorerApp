enum APIClient {
    static func performRequest<T: Codable>(router: RouterProtocol) async throws -> T {
        let request = try RequestBuilder.buildRequest(from: router)
        let rawData = try await RequestHandler.requestData(for: request)
        
        return try JSONDataDecoder.decode(data: rawData)
    }
}
