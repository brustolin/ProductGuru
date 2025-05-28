import SwiftUI

@Observable class ProductInfo: Identifiable {
    let product: Product
    var favorite: Bool = false
    
    init(product: Product, favorite: Bool) {
        self.product = product
        self.favorite = favorite
    }
}
