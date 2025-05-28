import SwiftUI

struct ActionButton : View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
        }
        .background(Color.accentColor)
        .foregroundStyle(.white)
        .buttonStyle(.bordered)
    }
}
