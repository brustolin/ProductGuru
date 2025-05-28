import Foundation

protocol ProductAPI {
    func getProducts(_ request: ProductListRequest) async throws  -> ProductListResponse
}

struct ProductListRequest : Endpoint {
    let offset: Int
    let limit: Int
    
    func asURLRequest() throws -> URLRequest {
        let urlString = "https://api.escuelajs.co/api/v1/products?offset=\(offset)&limit=\(limit)"
//        let urlString = "https://www.google.com" //comment the line above and uncomment this one to test the error view
        
        guard let url = URL(string: urlString)
        else { throw APIClientError.invalidURL(urlString) }
        return URLRequest(url: url)
    }
    
    func nextPage() -> Self {
        ProductListRequest(offset: offset + limit, limit: limit)
    }
}

struct ProductListResponse {
    let request: ProductListRequest
    let products: [Product]
}

class ProductAPIImp : ProductAPI {
    
    let apiClient: APIClient
    
    init(apiClient: APIClient = DefaultAPIClient()) {
        self.apiClient = apiClient
    }
    
    func getProducts(_ request: ProductListRequest) async throws -> ProductListResponse {
        do {
            let result = try await apiClient.request(request)
            let products = try JSONDecoder().decode([Product].self, from: result)
            return ProductListResponse(request: request, products: products)
        } catch {
            if error is URLError {
                throw APIClientError.networkError
            }
            throw APIClientError.unknownError(error)
        }
    }
    
}
