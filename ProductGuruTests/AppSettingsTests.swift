import Testing
import SwiftUI
@testable import ProductGuru

@Suite("AppSettings Tests")
struct AppSettingsTests {
    
    private class Fixture {
        let storage = MockStorage()
        
        func getSut() -> AppSettings {
            AppSettings(storage: storage)
        }
    }
    
    private let fixture = Fixture()
    
    @Test("Initial state loads saved theme as nil")
    func initialStateNoSavedTheme() {
        let viewModel = fixture.getSut()
        #expect(viewModel.appTheme == nil)
    }
    
    @Test("Initial state loads saved theme as light")
    func initialStateLightTheme() {
        fixture.storage.set(1, forKey: "appTheme")
        let viewModel = fixture.getSut()
        
        #expect(viewModel.appTheme == .light)
    }
    
    @Test("Initial state loads saved theme as dark")
    func initialStateDarkTheme() {
        fixture.storage.set(2, forKey: "appTheme")
        let viewModel = fixture.getSut()
        
        #expect(viewModel.appTheme == .dark)
    }
    
    @Test("Change theme to light")
    func changeThemeToLight() {
        let viewModel = fixture.getSut()
        
        viewModel.changeTheme(.light)
        
        #expect(viewModel.appTheme == .light)
        #expect(fixture.storage.setCalls.first?.value == 1)
        #expect(fixture.storage.setCalls.first?.key == "appTheme")
    }
    
    @Test("Change theme to dark")
    func changeThemeToDark() {
        let viewModel = fixture.getSut()
        
        viewModel.changeTheme(.dark)
        
        #expect(viewModel.appTheme == .dark)
        #expect(fixture.storage.setCalls.first?.value == 2)
        #expect(fixture.storage.setCalls.first?.key == "appTheme")
    }
    
    @Test("Change theme to nil")
    func changeThemeToNil() {
        let viewModel = fixture.getSut()
        
        viewModel.changeTheme(nil)
        
        #expect(viewModel.appTheme == nil)
        #expect(fixture.storage.setCalls.first?.value == 0)
        #expect(fixture.storage.setCalls.first?.key == "appTheme")
    }
}
