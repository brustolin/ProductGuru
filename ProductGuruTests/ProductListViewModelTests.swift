import Testing
import Foundation
@testable import ProductGuru

@Suite("ProductListViewModel Tests")
struct ProductListViewModelTests {
    
    private class Fixture {
        let api = MockProductAPI()
        let navigator = MockNavigator()
        let favoriteManager = MockFavoriteManager()
        
        func getSut() -> ProductListViewModel {
            ProductListViewModel(favoriteManager: favoriteManager, navigator: navigator, api: api)
        }
    }
    
    private var fixture = Fixture()
    
    @Test("Initial load success")
    func initialLoadSuccess() async {
        let products = ProductForPreview.generateProducts(amount: 7)
        let response = ProductListResponse(request: ProductListRequest(offset: 0, limit: 7), products: products)
        
        fixture.api.result = .success(response)
        fixture.favoriteManager.favorites = [0, 2]
        
        let viewModel = fixture.getSut()
        
        await viewModel.loadAsync()
        
        #expect(viewModel.state == .list)
        #expect(viewModel.products.count == 7)
        #expect(viewModel.products.first?.favorite == true)
        #expect(viewModel.products[1].favorite == false)
        #expect(!viewModel.hasMoreItens)
    }
    
    @Test("Initial load network error")
    func initialLoadNetworkError() async {
        fixture.api.result = .failure(APIClientError.networkError)
        let viewModel = fixture.getSut()
        
        await viewModel.loadAsync()
        
        #expect(viewModel.state == .errorNetwork)
        #expect(viewModel.products.count == 0)
    }
    
    @Test("Initial load unknown error")
    func initialLoadUnknownError() async {
        fixture.api.result = .failure(NSError(domain: "TestError", code: -1))
        let viewModel = fixture.getSut()
        
        await viewModel.loadAsync()
        
        #expect(viewModel.state == .errorUnknown)
        #expect(viewModel.products.count == 0)
    }
    
    @Test("Secondary load unknown error")
    func secondaryLoadUnknownError() async {
        let viewModel = fixture.getSut()
        let products = ProductForPreview.generateProducts(amount: 7)
        fixture.api.result = .success(ProductListResponse(request: ProductListRequest(offset: 0, limit: 7), products: products))
        
        await viewModel.loadAsync()
        fixture.api.result = .failure(NSError(domain: "TestError", code: -1))
        
        await viewModel.loadAsync()
        
        #expect(viewModel.state == .list)
    }
    
    @Test("Load next page test")
    func loadNextPage() async {
        let api = MockProductAPI()
        let firstProducts = ProductForPreview.generateProducts(amount: 7)
        let secondProducts = ProductForPreview.generateProducts(amount: 7, startId: 7)
        api.result = .success(ProductListResponse(request: ProductListRequest(offset: 0, limit: 7), products: firstProducts))
        
        let viewModel = ProductListViewModel(favoriteManager: MockFavoriteManager(), navigator: MockNavigator(), api: api)
        await viewModel.loadAsync()
        
        api.result = .success(ProductListResponse(request: ProductListRequest(offset: 7, limit: 7), products: secondProducts))
        await viewModel.loadAsync()
        
        #expect(viewModel.products.count == 14)
    }
    
    @Test("Test if hasMoreItens is true")
    func hasMoreItemsTrue() async {
        let products = ProductForPreview.generateProducts(amount: 20)
        fixture.api.result = .success(ProductListResponse(request: ProductListRequest(offset: 0, limit: 7), products: products))
        
        let viewModel = fixture.getSut()
        await viewModel.loadAsync()
        
        #expect(viewModel.hasMoreItens)
    }
    
    @Test("Warning behavior test")
    func warningBehavior() async {
        let viewModel = fixture.getSut()
        let products = ProductForPreview.generateProducts(amount: 7)
        fixture.api.result = .success(ProductListResponse(request: ProductListRequest(offset: 0, limit: 7), products: products))
        
        await viewModel.loadAsync()
        fixture.api.result = .failure(APIClientError.networkError)
        
        await viewModel.loadAsync()
        
        #expect(viewModel.warning != nil)
        #expect(viewModel.state == .list)
        
        viewModel.displayWarning()
        #expect(viewModel.shouldDisplayWarningAlert)
    }
    
    @Test("Select product test")
    func selectProduct() {
        let viewModel = fixture.getSut()
        let product = ProductInfo(product: ProductForPreview.previewProduct(), favorite: false)
        
        viewModel.selectProduct(product)
        #expect(fixture.navigator.selectedProduct?.id == product.id)
    }
}
