@testable import ProductGuru
import Foundation

class MockAPIClient: APIClient {
    enum ResultType {
        case success(Data)
        case failure(Error)
    }
    
    let result: ResultType
    
    init(result: ResultType) {
        self.result = result
    }
    
    func request(_ endpoint: Endpoint) async throws -> Data {
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
