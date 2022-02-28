//
//  SplashViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/11/2021.
//

import UIKit
import SVProgressHUD

class SplashViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.standard.setup() { error in
            ThemeManager.standard.setup()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataManagerSetup()
        themeManagerSetup()
        sessionManagerSetup()
    }
    
    // MARK: - Navigation

    @IBAction func unwindToSplash(unwindSegue: UIStoryboardSegue) { }
    
    private func dataManagerSetup() {
        if !DataManager.standard.isSetup {
            DataManager.standard.setup() { error in
                try? DataManager.standard.loadData()
            }
        } else {
            try? DataManager.standard.loadData()
        }
    }
    
    private func themeManagerSetup() {
        if !ThemeManager.standard.isSetup {
            ThemeManager.standard.setup()
            ThemeManager.standard.applyPreferedTheme()
        } else {
            ThemeManager.standard.applyPreferedTheme()
        }
    }
    
    private func sessionManagerSetup() {
        Task {
            let _ = await SessionManager.standard.setup()
            if SessionManager.standard.isSignedIn() {
                presentTabBarViewController()
            } else {
                presentSignInViewController()
            }
        }
    }
    
    private func presentSignInViewController() {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = storyBoard.instantiateViewController(identifier: "signInVC")
        tabBarViewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(tabBarViewController, animated: true, completion: nil)
    }
    
    private func presentTabBarViewController() {
        var rootViewController = UIApplication.shared.windows.first!.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = storyBoard.instantiateViewController(identifier: "tabBarVC")
        tabBarViewController.modalPresentationStyle = .fullScreen
        rootViewController?.present(tabBarViewController, animated: true, completion: nil)
    }
    
}
