import SwiftUI

enum ProductListState {
    case list
    case loading
    case errorNetwork
    case errorUnknown
    case noProduct
}

@Observable class ProductListViewModel : ProductListRefresher {
    private static let pageSize: Int = 20
    
    private var lastResponse: ProductListResponse?
    private var api: ProductAPI
    var isLoading: Bool = false
    
    private(set) var state: ProductListState = .list
    private(set) var products: [ProductInfo]
    private(set) var hasMoreItens : Bool = true
    private(set) var warning: String? = nil
    var shouldDisplayWarning: Bool = false
    
    let favoriteManager : FavoriteManager
    let navigator: ProductNavigator
    
    init(favoriteManager: FavoriteManager, navigator: ProductNavigator, api: ProductAPI = ProductAPIImp()){
        self.api = api
        self.favoriteManager = favoriteManager
        self.navigator = navigator
        products = []
    }
    
    func load() {
        Task {
            await loadAsync()
        }
    }
    
    func loadAsync() async {
        guard !isLoading else { return }
        isLoading = true
        
        if products.count == 0 {
            state = .loading
        }
        
        warning = nil
        let request = lastResponse?.request.nextPage() ?? ProductListRequest(offset: 0, limit: Self.pageSize)
        
        do {
            let response = try await api.getProducts(request)
            let productIds = response.products.map { $0.id }
            let favoriteIds = favoriteManager.loadFavoriteStatuses(for: productIds)
            
            products.append(contentsOf: response.products.map {
                ProductInfo(product: $0, favorite: favoriteIds.contains($0.id))
            })
            lastResponse = response
            if response.products.count < Self.pageSize {
                hasMoreItens = false
            }
            state = .list
        } catch APIClientError.networkError {
            // If we already displaying products to the user
            // we dont display the no network view, we show a warning indicator
            if products.count == 0 {
                state = .errorNetwork
            } else {
                warning = "A network error occurred\nPlease check your internet connection and try again"
            }
        } catch {
            // If we already displaying products to the user
            // we dont display the error view
            if products.count == 0 {
                state = .errorUnknown
            }
            // And then we log the error to investigate
            Log.error(error)
        }
        isLoading = false
    }
    
    func selectProduct(_ product: ProductInfo) {
        navigator.selectProduct(product)
    }
    
    func displayWarning() {
        guard warning != nil else { return }
        shouldDisplayWarning = true
    }
}
