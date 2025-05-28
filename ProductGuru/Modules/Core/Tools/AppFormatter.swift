import SwiftUI

@Observable class AppFormatter {
    func formatCurrency(_ value: Double) -> String {
        return String(format: "$ %.2f", value)
    }
}
