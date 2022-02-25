//
//  SessionManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation
import Alamofire

class SessionManager {
    
    // MARK: - Properties
    
    static let standard = SessionManager()
    let webServiceClient = GitHubClient()
    let userDefaultsPersistenceProvider = DataManager.standard.userDefaultsPersistenceProvider
    
    var sessionType: SessionType!
    var sessionUser: UserModel!
    var sessionToken: String!
    
    private var tokenHelper: TokenHelper!
    
    private init() {
        tokenHelper = TokenHelper()
    }
    
    // MARK: - Session Actions Methods
    
    func setup() async -> NetworkError? {
        getSessionAttributes()
        if sessionType == .authenticated {
            let networkError = await fetchAuthenticatedUser()
            if networkError == nil {
                return await validateAuthenticatedSession()
            }
            return networkError
        }
        return nil
    }
    
    func signIn(url: URL? = nil) async -> Bool {
        if let url = url {
            if let temporaryCode = extractTemporaryCode(with: url) {
                let accessToken = await fetchAccessToken(with: temporaryCode)
                if let accessToken = accessToken {
                    setSessionAttributes(sessionType: .authenticated, accessToken: accessToken)
                    return true
                } else {
                    return false
                }
            }
        } else {
            setSessionAttributes(sessionType: .guest, accessToken: nil)
            return true
        }
        return false
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
        userDefaultsPersistenceProvider.sessionTypeKey = sessionType 
    }
    
    private func getSessionType() {
        if let sessionType = userDefaultsPersistenceProvider.sessionTypeKey {
            self.sessionType = sessionType
        } else {
            setSessionAttributes(sessionType: .signedOut, accessToken: nil)
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

    private func fetchAuthenticatedUser() async -> NetworkError? {
        let result = await webServiceClient.fetchAuthenticatedUser()
        switch result {
        case .success(let response): sessionUser = response
                                     return nil
        case .failure(let networkError): return networkError
        }
    }
    
    private func validateAuthenticatedSession() async -> NetworkError? {
        let networkError = await webServiceClient.starRepository(fullName: "loay-ashraf/GitIt")
        if networkError == nil {
            let xNetworkError = await webServiceClient.unStarRepository(fullName: "loay-ashraf/GitIt")
            return xNetworkError
        }
        return networkError
    }
    
    // MARK: - Authentication Methods
    
    private func extractTemporaryCode(with callbackURL: URL) -> String? {
        let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
        if let temporaryCode = queryItems?.filter({$0.name == "code"}).first?.value {
            return temporaryCode
        }
        return nil
    }
    
    private func fetchAccessToken(with temporaryCode: String) async -> String? {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        let parameters = ["client_id": AuthenticationConstants.clientID,
                          "client_secret": AuthenticationConstants.clientSecret,
                          "code": temporaryCode]
        
        return await withUnsafeContinuation { continuation in
            AF.request(AuthenticationConstants.tokenExchangeURL,
                       method: .post,
                       parameters: parameters,
                       headers: headers)
                        .responseDecodable(of: AccessToken.self) { response in
                            guard let cred = response.value else {
                                return continuation.resume(returning: nil)
                            }
                            continuation.resume(returning: cred.accessToken)
                        }
        }
    }
    
}
