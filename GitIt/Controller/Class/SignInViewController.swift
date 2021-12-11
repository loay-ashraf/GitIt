//
//  SignInViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/10/2021.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {
    
    private var session: ASWebAuthenticationSession!
    
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var signInWithGithubButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appLogo.cornerRadius = 40
        signInWithGithubButton.cornerRadius = 10
        setupAuthentication()
    }
    
    @IBAction func signInWithGithub(_ sender: Any) {
        if NetworkReachability.shared.isInternetConnected {
            authenticate()
        } else {
            NetworkReachability.shared.presentNetworkReachabilityAlert(message: "You're not conntected to the internet, Can't connect to authentication server.", handler: nil)
        }
    }
    
    @IBAction func continueAsAGuest(_ sender: Any) {
        guestPrompt()
    }

}

extension SignInViewController: ASWebAuthenticationPresentationContextProviding {

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    private func setupAuthentication() {
        guard let authURL = URL(string: "https://ad8j39mya0.execute-api.us-east-2.amazonaws.com/Prod/gitit/login") else { return }
        let scheme = "gitit"
        session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { [weak self] callbackURL, error in
            if let error = error {
                let authenticationError = ASWebAuthenticationSessionError(_nsError: error as NSError)
                if authenticationError.code == ASWebAuthenticationSessionError.canceledLogin {
                    // re-setup authentication session
                    self?.setupAuthentication()
                }
            } else {
                guard callbackURL != nil else { return }
                SessionManager.standard.signIn(url: callbackURL)
                self?.performSegue(withIdentifier: "unwindToSplash", sender: self)
            }
        }
        session.presentationContextProvider = self
    }
    
    private func authenticate() {
        session.start()
    }
    
    private func setupGuest() {
        SessionManager.standard.signIn(url: nil)
        performSegue(withIdentifier: "unwindToSplash", sender: self)
    }
    
    private func guestPrompt() {
        let alertController = UIAlertController(title: "Continue As a Guest", message: "If you continue as a guest, features will be limted. Do you want to proceed?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default) {action in
            self.setupGuest()
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
