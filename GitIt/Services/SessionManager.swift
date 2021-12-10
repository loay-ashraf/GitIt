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
    }
    
    func signOut() {
        sessionUser = nil
        setSessionAttributes(sessionType: .signedOut, accessToken: "")
    }
    
    func setup(completion: @escaping () -> Void) {
        getSessionAttributes()
        if sessionType == .authenticated && NetworkReachability.shared.isInternetConnected {
            validateAuthenticatedSession(completion: completion)
        } else {
            completion()
        }
    }
    
    func isSignedIn() -> Bool {
        if sessionType == .authenticated || sessionType == .guest { return true }
        return false
    }
    
    private func setSessionAttributes(sessionType: SessionType, accessToken: String?) {
        self.sessionType = sessionType
        self.sessionToken = accessToken
        DataManager.shared.setSessionType(sessionType: sessionType)
        TokenManager.shared.storeAccessToken(accessToken: accessToken!)
    }
    
    private func getSessionAttributes() {
        sessionType = DataManager.shared.getSessionType()
        sessionToken = TokenManager.shared.retrieveAccessToken()
    }

    private func validateAuthenticatedSession(completion: (() -> Void)? = nil) {
        GithubClient.standard.getAuthenticatedUser() { response, error in
            if error == nil {
                self.sessionUser = response
            } else {
                self.setSessionAttributes(sessionType: .signedOut, accessToken: "")
            }
            completion?()
        }
    }
    
}
