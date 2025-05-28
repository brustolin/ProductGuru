import SwiftUI

struct Product: Codable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let images: [String]
}
