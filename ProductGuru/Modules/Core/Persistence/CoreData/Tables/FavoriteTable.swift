import CoreData
import Foundation

protocol FavoriteManager {
    func insert(productId: Int) throws
    func delete(productId: Int) throws
    func loadFavoriteStatuses(for productIds: [Int]) -> Set<Int>
}

final class FavoriteTable : FavoriteManager {
    private unowned let context : NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func insert(productId: Int) throws {
        let fav = FavoriteProduct(context: context)
        fav.productId = Int32(productId)
        try context.save()
    }
    
    func delete(productId: Int) throws {
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId == %d", productId)
        
        guard let favProduct = try context.fetch(fetchRequest).first else { return }
        context.delete(favProduct)
        try context.save()
    }
    
    func loadFavoriteStatuses(for productIds: [Int]) -> Set<Int> {
        let fetchRequest: NSFetchRequest<FavoriteProduct> = FavoriteProduct.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productId IN %@", productIds)
        
        do {
            let results = try context.fetch(fetchRequest)
            let ids = results.map { Int($0.productId) }
            return Set(ids)
        } catch {
            Log.error(error)
            return []
        }
    }
}

