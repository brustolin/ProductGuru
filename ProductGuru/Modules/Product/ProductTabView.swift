import SwiftUI

/// Protocol to control the navigation inside Products tab
protocol ProductNavigator {
    func selectProduct(_ product: ProductInfo)
    func dismissProductSelection()
}

@Observable
class ProductTabViewModel: ProductNavigator {
    var selectedProduct: ProductInfo? = nil
    
    func selectProduct(_ product: ProductInfo) {
        selectedProduct = product
    }
    
    func dismissProductSelection() {
        selectedProduct = nil
    }
}

struct ProductTabView : View {
    @State private var viewModel = ProductTabViewModel()
    @State private var api = ProductAPIImp()
    
    var favoriteManager: FavoriteManager
    
    var body: some View {
        ProductListScreen(favoriteManager: favoriteManager, navigator: viewModel, api: api)
        .sheet(item: $viewModel.selectedProduct) { prod in
            ProductDetailScreen(info: prod, favoriteManager: favoriteManager, navigator: viewModel)
        }
    }
}
