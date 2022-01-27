//
//  ThemeManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 10/01/2022.
//

import UIKit
import SVProgressHUD

class ThemeManager: NSObject {
    
    static let standard = ThemeManager()
    let userDefaultsHelper = DataManager.standard.userDefaultsHelper
    var isSetup: Bool = false
    
    // MARK: - Initialisation
    
    override private init() {
        super.init()
    }
    
    deinit {
        userDefaultsHelper.removeValueObserver(observer: self, for: "theme")
    }
    
    // MARK: - Setup Methods
    
    func setup() {
        isSetup = true
        userDefaultsHelper.addValueObserver(observer: self, for: "theme", options: [.new])
        setupProgressHUD()
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
        switch theme {
        case .followSystem: applySystemTheme()
        case .light: applyLightTheme()
        case .dark: applyDarkTheme()
        }
    }
    
    func applyPreferedTheme() {
        if let value = try? userDefaultsHelper.getValue(for: "theme").get() as? String, let theme = Theme(rawValue: value) {
            switch theme {
            case .followSystem: applySystemTheme()
            case .light: applyLightTheme()
            case .dark: applyDarkTheme()
            }
        }
    }
    
    private func applySystemTheme() {
        if let window = UIApplication.keyWindow() {
            window.overrideUserInterfaceStyle = .unspecified
        }
        let currentSystemTheme = UIScreen.main.traitCollection.userInterfaceStyle
        if currentSystemTheme == .light {
            UITextField.appearance().tintColor = .black
            SVProgressHUD.setDefaultStyle(.dark)
        } else if currentSystemTheme == .dark {
            UITextField.appearance().tintColor = .white
            SVProgressHUD.setDefaultStyle(.light)
        }
    }
    
    private func applyLightTheme() {
        if let window = UIApplication.keyWindow() {
            window.overrideUserInterfaceStyle = .light
        }
        UITextField.appearance().tintColor = .black
        SVProgressHUD.setDefaultStyle(.dark)
    }
    
    private func applyDarkTheme() {
        if let window = UIApplication.keyWindow() {
            window.overrideUserInterfaceStyle = .dark
        }
        UITextField.appearance().tintColor = .white
        SVProgressHUD.setDefaultStyle(.light)
    }
    
    // MARK: - Progress HUD Methods
    
    private func setupProgressHUD() {
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 50))
        SVProgressHUD.setMaximumDismissTimeInterval(1.0)
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.setHapticsEnabled(true)
    }
    
}
