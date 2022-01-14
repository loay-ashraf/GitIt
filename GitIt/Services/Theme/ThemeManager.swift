//
//  ThemeManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 10/01/2022.
//

import UIKit

class ThemeManager: NSObject {
    
    static let standard = ThemeManager()
    let userDefaultsHelper = DataManager.standard.userDefaultsHelper
    
    // MARK: - Initialisation
    
    override private init() {
        super.init()
    }
    
    deinit {
        userDefaultsHelper.removeValueObserver(observer: self, for: "theme")
    }
    
    // MARK: - Setup Methods
    
    func setup() {
        userDefaultsHelper.addValueObserver(observer: self, for: "theme", options: [.new])
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
            if let value = try? userDefaultsHelper.getValue(for: "theme").get() as? String, let theme = Theme(rawValue: value) {
                switch theme {
                case .followSystem: window.overrideUserInterfaceStyle = .unspecified
                case .light: window.overrideUserInterfaceStyle = .light
                case .dark: window.overrideUserInterfaceStyle = .dark
                }
            }
        }
    }
    
}
