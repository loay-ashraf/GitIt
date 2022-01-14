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
            let okAction = Constants.View.alert.okAction
            let alertTitle = Constants.View.alert.bookmarksError.title
            let alertMessage = Constants.View.alert.bookmarksError.message
            AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .alert, actions: [okAction])
        }
        SessionManager.standard.setup { networkError in
            if networkError != nil {
                let retryActionTitle = Constants.View.alert.startupError.retryActionTitle
                let exitActionTitle = Constants.View.alert.startupError.exitActionTitle
                let alertTitle = Constants.View.alert.startupError.title
                let alertMessage = Constants.View.alert.startupError.message
                let retyAction = UIAlertAction(title: retryActionTitle, style: .default) { action in self.retry() }
                let exitAction = UIAlertAction(title: exitActionTitle, style: .cancel) { action in self.exit() }
                AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .alert, actions: [retyAction,exitAction])
            } else {
                if SessionManager.standard.isSignedIn() {
                    self.presentTabBarViewController()
                } else {
                    self.presentSignInViewController()
                }
            }
        }
    }
    
    // MARK: - Navigation

    @IBAction func unwindToSplash(unwindSegue: UIStoryboardSegue) { }
    
    private func retry() {
        SessionManager.standard.setup { networkError in
            if networkError != nil {
                let retryActionTitle = Constants.View.alert.startupError.retryActionTitle
                let exitActionTitle = Constants.View.alert.startupError.exitActionTitle
                let alertTitle = Constants.View.alert.startupError.title
                let alertMessage = Constants.View.alert.startupError.message
                let retyAction = UIAlertAction(title: retryActionTitle, style: .default) { action in self.retry() }
                let exitAction = UIAlertAction(title: exitActionTitle, style: .cancel) { action in self.exit() }
                AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .alert, actions: [retyAction,exitAction])
            } else {
                if SessionManager.standard.isSignedIn() {
                    self.presentTabBarViewController()
                } else {
                    self.presentSignInViewController()
                }
            }
        }
    }
    
    private func exit() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (timer) in
            Darwin.exit(0)
        }
    }
    
    private func presentSignInViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = storyBoard.instantiateViewController(identifier: "signInVC")
        tabBarViewController.modalPresentationStyle = .fullScreen
        present(tabBarViewController, animated: true, completion: nil)
    }
    
    private func presentTabBarViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = storyBoard.instantiateViewController(identifier: "tabBarVC")
        tabBarViewController.modalPresentationStyle = .fullScreen
        present(tabBarViewController, animated: true, completion: nil)
    }

}
