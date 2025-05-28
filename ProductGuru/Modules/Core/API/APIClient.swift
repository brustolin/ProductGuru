import Foundation

enum APIClientError: Error {
    case invalidURL(String)
    case networkError
    case unknownError(Error)
}

protocol Endpoint {
    func asURLRequest() throws -> URLRequest
}

/// API describing protocol
protocol APIClient {
    func request(_ endpoint: any Endpoint) async throws -> Data
}

/// The default implementation for API calls
class DefaultAPIClient: APIClient {
    func request(_ endpoint: any Endpoint) async throws -> Data {
        let request = try endpoint.asURLRequest()
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
