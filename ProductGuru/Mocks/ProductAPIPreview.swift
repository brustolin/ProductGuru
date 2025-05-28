import SwiftUI

class ProductAPIPreview : ProductAPI {
    func getProducts(_ request: ProductListRequest) async throws -> ProductListResponse {
        return ProductListResponse(request: ProductListRequest(offset: 20, limit: 10), products:
                                    ProductForPreview.generateProducts(amount: 10))
    }
}
