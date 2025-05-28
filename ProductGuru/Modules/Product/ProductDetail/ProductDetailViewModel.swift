import SwiftUI

@Observable class ProductDetailViewModel {
    let favoriteManager: FavoriteManager
    let info: ProductInfo
    let navigator: ProductNavigator
    
    var product: Product {
        info.product
    }
    
    var isFavorite: Bool {
        info.favorite
    }
    
    init(favoriteManager: FavoriteManager, info: ProductInfo, navigator: ProductNavigator) {
        self.favoriteManager = favoriteManager
        self.info = info
        self.navigator = navigator
    }

    func toggleFavorite() {
        info.favorite.toggle()
        do {
            if isFavorite {
                try favoriteManager.insert(productId: product.id)
            } else {
                try favoriteManager.delete(productId: product.id)
            }
        } catch {
            Log.error(error)
        }
    }
    
    func carrosselImages() -> [URL] {
        // Remove invalid urls and duplications
        let set = Set(info.product.images.compactMap { URL(string: $0) })
        return Array(set)
    }
    
    func dismiss() {
        navigator.dismissProductSelection()
    }
}
