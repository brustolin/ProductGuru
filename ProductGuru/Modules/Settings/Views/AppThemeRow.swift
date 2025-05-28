import SwiftUI


struct AppThemeRow: View {
    let title: String
    let selected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button {
            onSelect()
        }
        label: {
            HStack {
                Text(title)
                Spacer()
                if selected {
                    Image(systemName: "checkmark")           
                }
            }
        }
    }
}
