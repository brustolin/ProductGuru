import SwiftUI

enum ErrorReason {
    case unknown
    case network
}

struct ErrorView : View {
    var reason: ErrorReason = .unknown
    
    var body: some View {
        let icon = reason == .unknown ? "exclamationmark.triangle.fill" : "wifi.slash"
        let message = reason == .unknown ? "Sorry!!\n\nAn unknown error occurred\nThe team was notified about it\nand will work to fix it" : "A network error occurred\nPlease check your internet connection and try again."
        
        VStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.red)
                .font(.system(size: 50))
            Text(message)
                .font(.headline)
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

#Preview {
    ErrorView()
}
