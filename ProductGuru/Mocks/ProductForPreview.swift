class ProductForPreview {
    static func generateProducts(amount: Int = 10, startId: Int = 0) -> [Product]{
        (startId..<(startId + amount)).map {
            Product(id: $0, title: "Product \($0)", price: Double($0 * 0), description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley", images: ["https://placehold.co/400x400/png"])
        }
    }
    
    static func previewProduct() -> Product {
        generateProducts(amount: 1)[0]
    }
}
