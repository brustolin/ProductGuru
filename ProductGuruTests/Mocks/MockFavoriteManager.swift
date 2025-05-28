import Testing
import Foundation
@testable import ProductGuru

class MockFavoriteManager: FavoriteManager {
        var favorites: Set<Int> = []
        func insert(productId: Int) throws {
            favorites.insert(productId)
        }
        
        func delete(productId: Int) throws {
            favorites.remove(productId)
        }
        
        func loadFavoriteStatuses(for ids: [Int]) -> Set<Int> {
            favorites.intersection(ids)
        }
    }
