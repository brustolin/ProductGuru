import Testing
import Foundation
@testable import ProductGuru

class MockProductAPI: ProductAPI {
    var result: Result<ProductListResponse, Error> = .success(ProductListResponse(request: ProductListRequest(offset: 0, limit: 7), products: []))
    
    func getProducts(_ request: ProductListRequest) async throws -> ProductListResponse {
        switch result {
        case .success(let response): return response
        case .failure(let error): throw error
        }
    }
}
