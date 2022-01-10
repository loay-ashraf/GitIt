//
//  ThemeManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 10/01/2022.
//

import UIKit

class ThemeManager: NSObject {
    
    static let standard = ThemeManager()
    
    // MARK: - Initialisation
    
    override private init() {
        super.init()
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: "theme", context: nil)
    }
    
    // MARK: - Setup Methods
    
    func setup() {
        UserDefaults.standard.addObserver(self, forKeyPath: "theme", options: [.new], context: nil)
    }
    
    // MARK: - Observer Methods
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == "theme" else { return }
        if let newTheme = Theme(rawValue: change[.newKey] as! String) {
            ThemeManager.standard.applyTheme(theme: newTheme)
        }
    }
    
    // MARK: - Theme Application Methods
    
    func applyTheme(theme: Theme) {
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            switch theme {
            case .followSystem: window.overrideUserInterfaceStyle = .unspecified
            case .light: window.overrideUserInterfaceStyle = .light
            case .dark: window.overrideUserInterfaceStyle = .dark
            }
        }
    }
    
    func applyPreferedTheme() {
        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            do {
                let theme = try LibraryManager.standard.getTheme().get()
                switch theme {
                case .followSystem: window.overrideUserInterfaceStyle = .unspecified
                case .light: window.overrideUserInterfaceStyle = .light
                case .dark: window.overrideUserInterfaceStyle = .dark
                }
            } catch {
                
            }
        }
    }
    
}
