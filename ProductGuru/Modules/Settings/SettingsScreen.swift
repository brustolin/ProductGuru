import SwiftUI

struct SettingsScreen : View {
    var settings: AppSettings
    
    var body: some View {
        List {
            Section("App Theme") {
                AppThemeRow(title: "System Default", selected: settings.appTheme == .none ) {
                    settings.changeTheme(nil)
                }
                AppThemeRow(title: "Light", selected: settings.appTheme == .light ) {
                    settings.changeTheme(.light)
                }
                AppThemeRow(title: "Dark", selected: settings.appTheme == .dark ) {
                    settings.changeTheme(.dark)
                }
            }
        }.navigationTitle("Settings")
    }
}
