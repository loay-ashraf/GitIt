//
//  SessionManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation

class SessionManager {
    
    static let standard = SessionManager()
    
    var sessionType: SessionType!
    var sessionUser: UserModel!
    var sessionToken: String!
    
    private var tokenHelper: TokenHelper!
    
    private init() {
        tokenHelper = TokenHelper()
    }
    
    // MARK: - Session Actions Methods
    
    func setup(completion: @escaping (NetworkError?) -> Void) {
        getSessionAttributes()
        if sessionType == .authenticated {
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
    
    func signIn(url: URL?) {
        if let url = url {
            let queryItems = URLComponents(string: url.absoluteString)?.queryItems
            let accessToken = queryItems?.filter({$0.name == "access-token"}).first?.value
            setSessionAttributes(sessionType: .authenticated, accessToken: accessToken)
        } else {
            setSessionAttributes(sessionType: .guest, accessToken: nil)
        }
    }
    
    func signOut() {
        sessionUser = nil
        setSessionAttributes(sessionType: .signedOut, accessToken: nil)
    }
    
    func isSignedIn() -> Bool {
        if sessionType == .authenticated || sessionType == .guest { return true }
        return false
    }
    
    // MARK: - Session Attributes Methods
    
    private func setSessionAttributes(sessionType: SessionType, accessToken: String?) {
        setSessionType(sessionType: sessionType)
        setSessionToken(sessionToken: accessToken)
    }
    
    private func getSessionAttributes() {
        getSessionType()
        if sessionType == .authenticated { getSessionToken() }
    }
    
    private func setSessionType(sessionType: SessionType) {
        self.sessionType = sessionType
        LibraryManager.standard.setSessionType(sessionType: sessionType)
    }
    
    private func getSessionType() {
        let sessionTypeResult = LibraryManager.standard.getSessionType()
        switch sessionTypeResult {
        case .success(let sessionType): self.sessionType = sessionType
        case .failure(LibraryError.userDefaults): setSessionAttributes(sessionType: .signedOut, accessToken: nil)
        default: return
        }
    }
    
    private func setSessionToken(sessionToken: String?) {
        let error = tokenHelper.storeToken(accessToken: sessionToken)
        if error != nil {
            setSessionType(sessionType: .signedOut)
            self.sessionToken = nil
        } else {
            self.sessionToken = sessionToken
        }
    }
    
    private func getSessionToken() {
        if sessionType == .authenticated {
            let sessionTokenResult = tokenHelper.retrieveToken()
            switch sessionTokenResult {
            case .success(let sessionToken): self.sessionToken = sessionToken
            case .failure(_): setSessionType(sessionType: .signedOut)
            }
        }
    }
    
    // MARK: - Authenticated Session Methods

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
                self.setSessionAttributes(sessionType: .signedOut, accessToken: nil)
                completion(networkError)
            }
        }
    }
    
}
