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
        } else {
            setSessionAttributes(sessionType: .guest, accessToken: "")
        }
    }
    
    func signOut() {
        sessionUser = nil
        setSessionAttributes(sessionType: .signedOut, accessToken: "")
    }
    
    func setup(completion: @escaping (NetworkError?) -> Void) {
        getSessionAttributes()
        if sessionType == .authenticated && NetworkReachability.shared.isInternetConnected {
            fetchAuthenticatedUser() { networkError in
                if networkError == nil {
                    self.validateAuthenticatedSession(completion: completion)
                } else {
                    completion(networkError)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func isSignedIn() -> Bool {
        if sessionType == .authenticated || sessionType == .guest { return true }
        return false
    }
    
    func isAuthenticated() -> Bool {
        return sessionType == .authenticated ? true : false
    }
    
    func isGuest() -> Bool {
        return sessionType == .guest ? true : false
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

    private func fetchAuthenticatedUser(completion: @escaping (NetworkError?) -> Void) {
        NetworkClient.standard.getAuthenticatedUser() { result in
            switch result {
            case .success(let response): self.sessionUser = response
                                         completion(nil)
            case .failure(let networkError): completion(networkError)
            }
        }
    }
    
    private func validateAuthenticatedSession(completion: @escaping (NetworkError?) -> Void) {
        NetworkClient.standard.authenticatedUserStar(fullName: "loay-ashraf/GitIt") { networkError in
            if networkError == nil {
                NetworkClient.standard.authenticatedUserUnstar(fullName: "loay-ashraf/GitIt", completionHandler: completion)
            } else {
                self.setSessionAttributes(sessionType: .signedOut, accessToken: "")
                completion(networkError)
            }
        }
    }
    
}
