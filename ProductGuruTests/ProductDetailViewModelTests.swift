import Testing
@testable import ProductGuru

@Suite("ProductDetailViewModel Tests")
struct ProductDetailViewModelTests {
    
    private class Fixture {
        let favoriteManager = MockFavoriteManager()
        let navigator = MockNavigator()
        
        func getSut(info: ProductInfo) -> ProductDetailViewModel {
            ProductDetailViewModel(favoriteManager: favoriteManager, info: info, navigator: navigator)
        }
    }
    
    private var fixture = Fixture()
    
    @Test("Initial state test")
    func initialState() {
        let product = ProductForPreview.previewProduct()
        let info = ProductInfo(product: product, favorite: true)
        let viewModel = fixture.getSut(info: info)
        
        #expect(viewModel.product.id == product.id)
        #expect(viewModel.isFavorite)
    }
    
    @Test("Toggle favorite inserts when not favorite")
    func toggleFavoriteInserts() {
        let product = ProductForPreview.previewProduct()
        let info = ProductInfo(product: product, favorite: false)
        let viewModel = fixture.getSut(info: info)
        
        viewModel.toggleFavorite()
        
        #expect(viewModel.isFavorite)
        #expect(fixture.favoriteManager.favorites.contains(product.id))
    }
    
    @Test("Toggle favorite deletes when favorite")
    func toggleFavoriteDeletes() {
        let product = ProductForPreview.previewProduct()
        let info = ProductInfo(product: product, favorite: true)
        let viewModel = fixture.getSut(info: info)
        
        fixture.favoriteManager.favorites = [product.id]
        
        #expect(fixture.favoriteManager.favorites.contains(product.id))
        viewModel.toggleFavorite()
        
        #expect(!viewModel.isFavorite)
        #expect(!fixture.favoriteManager.favorites.contains(product.id))
    }
    
    @Test("Dismiss test")
    func dismissTest() {
        let product = ProductForPreview.previewProduct()
        let info = ProductInfo(product: product, favorite: false)
        
        fixture.navigator.selectProduct(info)
        #expect(fixture.navigator.selectedProduct != nil)
        
        let viewModel = fixture.getSut(info: info)
        viewModel.dismiss()
        
        #expect(fixture.navigator.selectedProduct == nil)
    }
    
    @Test("Carrossel images removes invalid and duplicates")
    func carrosselImagesTest() {
        let urls = [
            "invalid-url",
            "https://example.com/image1.jpg",
            "https://example.com/image1.jpg", // duplicate
            "https://example.com/image2.jpg",
        ]
        let product = Product(id: 0, title: "Test Product", price: 10, description: "", images: urls)
        
        let info = ProductInfo(product: product, favorite: false)
        let viewModel = fixture.getSut(info: info)
        
        let carousel = viewModel.carrosselImages()
        
        #expect(carousel.count == 3)
        #expect(carousel.contains(where: { $0.absoluteString == "invalid-url" }))
        #expect(carousel.contains(where: { $0.absoluteString == "https://example.com/image1.jpg" }))
        #expect(carousel.contains(where: { $0.absoluteString == "https://example.com/image2.jpg" }))
    }
}
