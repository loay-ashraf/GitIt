//
//  WelcomeViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/10/2021.
//

import UIKit
import AuthenticationServices

class rootViewController: UIViewController {
    
    @IBOutlet weak var signInWithGithubButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInWithGithubButton.layer.cornerRadius = 20
    }
    
    @IBAction func continueAsAGuest(_ sender: Any) {
        let alertController = UIAlertController(title: "Continue As a Guest", message: "If you continue as a guest, features will be limted. Do you want to proceed?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default) {action in
            SessionManager.shared.signIn(urlContext: nil)
            let rootVC = self.storyboard?.instantiateViewController(identifier: "rootTabBarVC")
            rootVC!.modalPresentationStyle = .fullScreen
            self.present(rootVC!, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SignInViewController
        vc.modalPresentationStyle = .fullScreen
    }

}
