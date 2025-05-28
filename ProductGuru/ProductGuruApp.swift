import SwiftUI

@main
struct ProductGuruApp: App {
    let dataManager = ProductGuruDataManager()
    
    private var formatter = AppFormatter()
    private var settings = AppSettings()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationStack {
                    ProductTabView(favoriteManager: dataManager.favorites)
                }.tabItem {
                    Label("Products", systemImage: "shippingbox.fill")
                }
                
                NavigationStack {
                    SettingsScreen(settings: settings)
                }.tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
            }
            .environment(formatter)
            .preferredColorScheme(settings.appTheme)
            .tint(.accentColor)
        }
    }
}
