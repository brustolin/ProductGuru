import CoreData

final class ProductGuruDataManager {
    private let persistentContainer: NSPersistentContainer
    
    let favorites: FavoriteTable
    
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "ProductGuru")
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        favorites = FavoriteTable(context: persistentContainer.viewContext)
    }
}
