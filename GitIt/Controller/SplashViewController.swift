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
        SessionManager.standard.setup {
            if SessionManager.standard.isSignedIn() {
                self.presentTabBarViewController()
            } else {
                self.presentSignInViewController()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func presentSignInViewController() {
        let rootViewController = UIApplication.shared.windows.first!.rootViewController
        let tabBarViewController = rootViewController?.storyboard?.instantiateViewController(identifier: "signInVC")
        tabBarViewController!.modalPresentationStyle = .fullScreen
        rootViewController!.present(tabBarViewController!, animated: true, completion: nil)
    }
    
    private func presentTabBarViewController() {
        let rootViewController = UIApplication.shared.windows.first!.rootViewController
        let tabBarViewController = rootViewController?.storyboard?.instantiateViewController(identifier: "tabBarVC")
        tabBarViewController!.modalPresentationStyle = .fullScreen
        rootViewController!.present(tabBarViewController!, animated: true, completion: nil)
    }

}
