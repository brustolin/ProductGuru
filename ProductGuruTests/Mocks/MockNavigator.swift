import Testing
import Foundation
@testable import ProductGuru

class MockNavigator: ProductNavigator {
        var selectedProduct: ProductInfo? = nil
        
        func selectProduct(_ product: ProductInfo) {
            selectedProduct = product
        }
        
        func dismissProductSelection() {
            selectedProduct = nil
        }
    }
