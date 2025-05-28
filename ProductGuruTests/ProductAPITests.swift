import Testing
import Foundation
@testable import ProductGuru

@Suite("ProductAPI Tests")
struct ProductAPITests {
    @Test("ProductListRequest generates valid URLRequest")
    func productListRequestValid() throws {
        let request = ProductListRequest(offset: 10, limit: 20)
        let urlRequest = try request.asURLRequest()
        
        #expect(urlRequest.url?.absoluteString == "https://api.escuelajs.co/api/v1/products?offset=10&limit=20")
    }
    
    @Test("ProductListRequest nextPage produces correct request")
    func productListRequestNextPage() {
        let request = ProductListRequest(offset: 0, limit: 10)
        let next = request.nextPage()
        
        #expect(next.offset == 10)
        #expect(next.limit == 10)
    }
    
    @Test("ProductAPIImp success decoding")
    func productAPIImpSuccess() async throws {
        let fakeProduct = ProductForPreview.previewProduct()
        let data = try JSONEncoder().encode([fakeProduct])
        let apiClient = MockAPIClient(result: .success(data))
        let api = ProductAPIImp(apiClient: apiClient)
        
        let request = ProductListRequest(offset: 0, limit: 1)
        let response = try await api.getProducts(request)
        
        #expect(response.products.first == fakeProduct)
    }
    
    @Test("ProductAPIImp handles URLError as network error")
    func productAPIImpURLError() async {
        let apiClient = MockAPIClient(result: .failure(URLError(.notConnectedToInternet)))
        let api = ProductAPIImp(apiClient: apiClient)
        let request = ProductListRequest(offset: 0, limit: 1)
        
        do {
            _ = try await api.getProducts(request)
            Issue.record("Should have failed with network error")
        } catch APIClientError.networkError {
            // The standard way to test for an exception is with #expect(throws:)
            // but in order for it to work the error needs to implement Equatable
            // APIClientError is an enumeration with associated values and it does not get Equatable out of the box
            print("Success")
        } catch {
            Issue.record("Should have failed with network error")
        }
    }
    
    @Test("ProductAPIImp handles unknown error")
    func productAPIImpUnknownError() async {
        let error = NSError(domain: "TestError", code: -1)
        let apiClient = MockAPIClient(result: .failure(error))
        let api = ProductAPIImp(apiClient: apiClient)
        let request = ProductListRequest(offset: 0, limit: 1)
        
        
        await #expect(throws: (any Error).self) {
            _ = try await api.getProducts(request)
        }
    }
}
