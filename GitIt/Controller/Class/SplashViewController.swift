//
//  SplashViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/11/2021.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DataController.standard.load()
        NetworkReachability.shared.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SessionManager.standard.setup {
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
