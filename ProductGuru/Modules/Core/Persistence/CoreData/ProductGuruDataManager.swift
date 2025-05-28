import CoreData

final class ProductGuruDataManager {
    private let persistentContainer: NSPersistentContainer
    
    let favorites: FavoriteTable
    
    init() {
        persistentContainer = NSPersistentContainer(name: "ProductGuru")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        favorites = FavoriteTable(context: persistentContainer.viewContext)
    }
}
