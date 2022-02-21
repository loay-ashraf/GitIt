//
//  SessionManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation
import Alamofire

class SessionManager {
    
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
    
    func signIn(url: URL? = nil, completionHandler: @escaping (Bool) -> Void) {
        if let url = url {
            if let temporaryCode = extractTemporaryCode(with: url) {
                fetchAccessToken(with: temporaryCode) { accessToken in
                    if let accessToken = accessToken {
                        self.setSessionAttributes(sessionType: .authenticated, accessToken: accessToken)
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                }
            }
        } else {
            setSessionAttributes(sessionType: .guest, accessToken: nil)
            completionHandler(true)
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

    private func fetchAuthenticatedUser(completion: @escaping (NetworkError?) -> Void) {
        webServiceClient.fetchAuthenticatedUser() { result in
            switch result {
            case .success(let response): self.sessionUser = response
                                         completion(nil)
            case .failure(let networkError): completion(networkError)
            }
        }
    }
    
    private func validateAuthenticatedSession(completion: @escaping (NetworkError?) -> Void) {
        webServiceClient.starRepository(fullName: "loay-ashraf/GitIt") { networkError in
            if networkError == nil {
                self.webServiceClient.unStarRepository(fullName: "loay-ashraf/GitIt", completionHandler: completion)
            } else {
                completion(networkError)
            }
        }
    }
    
    // MARK: - Authentication Methods
    
    private func extractTemporaryCode(with callbackURL: URL) -> String? {
        let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
        if let temporaryCode = queryItems?.filter({$0.name == "code"}).first?.value {
            return temporaryCode
        }
        return nil
    }
    
    private func fetchAccessToken(with temporaryCode: String, completionHandler: @escaping (String?) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        let parameters = ["client_id": AuthenticationConstants.clientID,
                          "client_secret": AuthenticationConstants.clientSecret,
                          "code": temporaryCode]
        AF.request(AuthenticationConstants.tokenExchangeURL,
                   method: .post,
                   parameters: parameters,
                   headers: headers)
                    .responseDecodable(of: AccessToken.self) { response in
                        guard let cred = response.value else {
                            return completionHandler(nil)
                        }
                        completionHandler(cred.accessToken)
                    }
        
    }
    
}
