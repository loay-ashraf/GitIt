//
//  SplashViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/11/2021.
//

import UIKit

class SplashViewController: UIViewController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.standard.setup() { error in
            ThemeManager.standard.setup()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ThemeManager.standard.applyPreferedTheme()
        do {
            try DataManager.standard.loadData()
        } catch {
            AlertHelper.showAlert(alert: .dataError)
        }
        SessionManager.standard.setup { networkError in
            if networkError != nil {
                AlertHelper.showAlert(alert: .networkError)
            }
            if SessionManager.standard.isSignedIn() {
                self.presentTabBarViewController()
            } else {
                self.presentSignInViewController()
            }
        }
    }
    
    // MARK: - Navigation

    @IBAction func unwindToSplash(unwindSegue: UIStoryboardSegue) { }
    
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
