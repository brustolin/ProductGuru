import Testing
@testable import ProductGuru
import Foundation

@Suite("Test Product full cycle")
struct ProductFunctionalTests {
    
    @Test("Load a json, navigate to detail, mark as favorite")
    func runTest() async throws {
        let json = try loadJSONData(named: "data")
        let persistanceManager = ProductGuruDataManager(inMemory: true)
        let favoriteManager = persistanceManager.favorites
        let mockAPIClient = MockAPIClient(result: .success(json))
        let productAPI = ProductAPIImp(apiClient: mockAPIClient)
        let navigator = ProductTabViewModel()
        
        let listViewModel = ProductListViewModel(favoriteManager: favoriteManager, navigator: navigator, api: productAPI)
        
        await listViewModel.loadAsync()
        listViewModel.selectProduct(listViewModel.products[0])
        
        let selectedProduct = try #require(navigator.selectedProduct)
        
        let detailViewModel = ProductDetailViewModel(favoriteManager: favoriteManager, info: selectedProduct, navigator: navigator)
        
        #expect(detailViewModel.isFavorite == false)
        detailViewModel.toggleFavorite()
        #expect(detailViewModel.isFavorite)
        
        #expect(favoriteManager.loadFavoriteStatuses(for: [12]) == [12])
    }
    
    private func loadJSONData(named name: String) throws -> Data {
        let bundle = Bundle(for: MockAPIClient.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw NSError(domain: "Missing file", code: -1)
        }
        return try Data(contentsOf: url)
    }
}
