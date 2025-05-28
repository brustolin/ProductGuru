import SwiftUI

protocol AppSettingsStorage {
    func set(_ value: Int, forKey defaultName: String)
    func integer(forKey defaultName: String) -> Int
}

@Observable class AppSettings {
    private let storage: AppSettingsStorage
    
    private(set) var appTheme : ColorScheme? = .none
    
    init(storage: AppSettingsStorage = UserDefaults.standard) {
        self.storage = storage
        appTheme = savedTheme()
    }
    
    func changeTheme(_ newTheme : ColorScheme?) {
        self.appTheme = newTheme
        
        if let newTheme {
            storage.set(newTheme == .light ? 1 : 2 , forKey: "appTheme")
        } else {
            storage.set(0, forKey: "appTheme")
        }
    }
    
    private func savedTheme() -> ColorScheme? {
        let savedTheme = storage.integer(forKey: "appTheme")
        guard savedTheme != 0 else { return nil }
        return savedTheme == 1 ? .light : .dark
    }
}

extension UserDefaults : AppSettingsStorage {
}
