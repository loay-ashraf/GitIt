//
//  SessionManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation
import UIKit

class SessionManager {
    
    static let standard = SessionManager()
    
    var sessionType: SessionType!
    var sessionUser: UserModel!
    var sessionToken: String!
    
    private init() {
        
    }
    
    func signIn(url: URL?) {
        if let url = url {
            let queryItems = URLComponents(string: url.absoluteString)?.queryItems
            let accessToken = queryItems?.filter({$0.name == "access-token"}).first?.value
            setSessionAttributes(sessionType: .authenticated, accessToken: accessToken)
            validateAuthenticatedSession()
        } else {
            setSessionAttributes(sessionType: .guest, accessToken: "")
        }
        presentTabBarViewController()
    }
    
    func signOut<Controller: UIViewController>(currentViewController: Controller) {
        sessionUser = nil
        setSessionAttributes(sessionType: .signedOut, accessToken: "")
        presentRootViewController(currentViewController: currentViewController)
    }
    
    func setup(completion: @escaping () -> Void) {
        getSessionAttributes()
        if let sessionType = self.sessionType {
            if sessionType == .authenticated && NetworkReachability.shared.isInternetConnected {
                validateAuthenticatedSession(completion: completion)
            }
        } else {
            setSessionAttributes(sessionType: .signedOut, accessToken: "")
            completion()
        }
    }
    
    func isSignedIn() -> Bool {
        if self.sessionType == .authenticated || self.sessionType == .guest {
            return true
        }
        return false
    }
    
    private func setSessionAttributes(sessionType: SessionType, accessToken: String?) {
        self.sessionType = sessionType
        self.sessionToken = accessToken
        DataManager.shared.setSessionType(sessionType: sessionType)
        TokenManager.shared.storeAccessToken(accessToken: accessToken!)
    }
    
    private func getSessionAttributes() {
        self.sessionType = DataManager.shared.getSessionType()
        self.sessionToken = TokenManager.shared.retrieveAccessToken()
    }

    private func validateAuthenticatedSession(completion: (() -> Void)? = nil) {
        GitClient.standard.getAuthenticatedUser() { response, error in
            if error == nil {
                self.sessionUser = response
            } else {
                self.setSessionAttributes(sessionType: .signedOut, accessToken: "")
            }
            completion!()
        }
    }
    
    private func presentTabBarViewController() {
        let rootViewController = UIApplication.shared.windows.first!.rootViewController as! SignInViewController
        let tabBarViewController = rootViewController.storyboard?.instantiateViewController(identifier: "tabBarVC")
        tabBarViewController!.modalPresentationStyle = .fullScreen
        rootViewController.present(tabBarViewController!, animated: true, completion: nil)
    }
    
    private func presentRootViewController<Controller: UIViewController>(currentViewController: Controller) {
        currentViewController.performSegue(withIdentifier: "unwindToRoot", sender: currentViewController)
    }
    
}
