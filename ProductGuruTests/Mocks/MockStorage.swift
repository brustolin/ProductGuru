import SwiftUI
@testable import ProductGuru

class MockStorage: AppSettingsStorage {
    var storage: [String: Int] = [:]
    var setCalls: [(value: Int, key: String)] = []
    
    func set(_ value: Int, forKey defaultName: String) {
        setCalls.append((value, defaultName))
        storage[defaultName] = value
    }
    
    func integer(forKey defaultName: String) -> Int {
        return storage[defaultName] ?? 0
    }
}
