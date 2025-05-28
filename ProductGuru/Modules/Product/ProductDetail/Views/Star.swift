import SwiftUI

struct Star: View {
    let active: Bool
    var body: some View {
        Image(systemName: active ? "star.fill" : "star")
            .tint(.yellow)
    }
}
