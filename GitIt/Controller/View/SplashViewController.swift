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
        CoreDataManager.standard.load()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SessionManager.standard.setup { networkError in
            if networkError != nil {
                let retyAction = UIAlertAction(title: "Retry", style: .default) { action in self.retry() }
                let exitAction = UIAlertAction(title: "Exit", style: .cancel) { action in self.exit() }
                AlertHelper.showAlert(title: "Network Error", message: "We can't connect to server at time, would you like to rety or exit?", style: .alert, actions: [retyAction,exitAction])
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
                let retyAction = UIAlertAction(title: "Retry", style: .default) { action in self.retry() }
                let exitAction = UIAlertAction(title: "Exit", style: .cancel) { action in self.exit() }
                AlertHelper.showAlert(title: "Network Error", message: "We can't connect to server at time, would you like to rety or exit?", style: .alert, actions: [retyAction,exitAction])
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
