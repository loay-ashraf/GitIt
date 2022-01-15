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
        if NetworkManager.standard.isInternetConnected {
            authenticate()
        } else {
            AlertHelper.showAlert(alert: .internetError)
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
                } else {
                    AlertHelper.showAlert(alert: .signInError)
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
    
    private func guestPrompt() {
        AlertHelper.showAlert(alert: .guestSignIn({ [weak self] in
            self?.setupGuest()
        }))
    }
    
    private func setupGuest() {
        SessionManager.standard.signIn(url: nil)
        performSegue(withIdentifier: "unwindToSplash", sender: self)
    }
    
}


