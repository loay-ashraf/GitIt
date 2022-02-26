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
    @IBOutlet weak var signInWithGithubButton: AdaptableSizeButton!
    @IBOutlet weak var continueAsAGuestButton: AdaptableSizeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAuthenticationSession()
    }
    
    @IBAction func signInWithGithub(_ sender: Any) {
        authenticate()
    }
    
    @IBAction func continueAsAGuest(_ sender: Any) {
        guestPrompt()
    }

}

extension SignInViewController: ASWebAuthenticationPresentationContextProviding {

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
    
    private func setupAuthenticationSession() {
        session = ASWebAuthenticationSession(url: AuthenticationConstants.authorizationURL, callbackURLScheme: AuthenticationConstants.callbackURLScheme) { [weak self] callbackURL, error in
            if let error = error {
                let authenticationError = ASWebAuthenticationSessionError(_nsError: error as NSError)
                if authenticationError.code == ASWebAuthenticationSessionError.canceledLogin {
                    // re-setup authentication session
                    self?.setupAuthenticationSession()
                } else {
                    AlertHelper.showAlert(alert: .signInError)
                }
            } else if let callbackURL = callbackURL {
                self?.handleCallbackURL(withCallbackURL: callbackURL)
            }
        }
        session.presentationContextProvider = self
    }
    
    private func authenticate() {
        session.start()
    }
    
    private func handleCallbackURL(withCallbackURL url: URL) {
        Task {
            let success = await SessionManager.standard.signIn(url: url)
            if success {
                performSegue(withIdentifier: "unwindToSplash", sender: self)
            } else {
                AlertHelper.showAlert(alert: .signInError)
            }
        }
    }
    
    private func guestPrompt() {
        AlertHelper.showAlert(alert: .guestSignIn({ [weak self] in
            self?.setupGuest()
        }))
    }
    
    private func setupGuest() {
        Task {
            let success = await SessionManager.standard.signIn()
            if success {
                performSegue(withIdentifier: "unwindToSplash", sender: self)
            }
        }
    }
    
}


