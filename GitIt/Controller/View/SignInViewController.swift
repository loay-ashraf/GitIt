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
            let alertTitle = Constants.View.alert.noInternetError.title
            let alertMessage = Constants.View.alert.noInternetError.message
            let okAction = Constants.View.alert.okAction
            AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .alert, actions: [okAction])
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
                    let alertTitle = Constants.View.alert.signInError.title
                    let alertMessage = Constants.View.alert.signInError.message
                    let okAction = Constants.View.alert.okAction
                    AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .alert, actions: [okAction])
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
        let alertTitle = Constants.View.alert.guestSignIn.title
        let alertMessage = Constants.View.alert.guestSignIn.message
        let continueActionTitle = Constants.View.alert.guestSignIn.continueActionTitle
        let continueAction = UIAlertAction(title: continueActionTitle, style: .default) { action in self.setupGuest() }
        let cancelAction = Constants.View.alert.cancelAction
        AlertHelper.showAlert(title: alertTitle, message: alertMessage, style: .actionSheet, actions: [continueAction,cancelAction])
    }
    
}
