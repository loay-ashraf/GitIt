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
        if let window = UIApplication.keyWindow() {
            let currentSystemTheme = UIScreen.main.traitCollection.userInterfaceStyle
            switch theme {
            case .followSystem: window.overrideUserInterfaceStyle = .unspecified
                if currentSystemTheme == .light {
                    SVProgressHUD.setDefaultStyle(.dark)
                } else if currentSystemTheme == .dark {
                    SVProgressHUD.setDefaultStyle(.light)
                }
            case .light: window.overrideUserInterfaceStyle = .light; SVProgressHUD.setDefaultStyle(.dark)
            case .dark: window.overrideUserInterfaceStyle = .dark; SVProgressHUD.setDefaultStyle(.light)
            }
        }
    }
    
    func applyPreferedTheme() {
        if let window = UIApplication.keyWindow() {
            let currentSystemTheme = UIScreen.main.traitCollection.userInterfaceStyle
            if let value = try? userDefaultsHelper.getValue(for: "theme").get() as? String, let theme = Theme(rawValue: value) {
                switch theme {
                case .followSystem: window.overrideUserInterfaceStyle = .unspecified
                    if currentSystemTheme == .light {
                        SVProgressHUD.setDefaultStyle(.dark)
                    } else if currentSystemTheme == .dark {
                        SVProgressHUD.setDefaultStyle(.light)
                    }
                case .light: window.overrideUserInterfaceStyle = .light; SVProgressHUD.setDefaultStyle(.dark)
                case .dark: window.overrideUserInterfaceStyle = .dark; SVProgressHUD.setDefaultStyle(.light)
                }
            }
        }
    }
    
    // MARK: - Progress HUD Methods
    
    private func setupProgressHUD() {
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 50))
        SVProgressHUD.setMaximumDismissTimeInterval(1.0)
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.setHapticsEnabled(true)
    }
    
}
