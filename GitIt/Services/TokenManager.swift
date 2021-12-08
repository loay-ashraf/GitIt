//
//  TokenManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation

class TokenManager {
    
    static let shared = TokenManager()
    
    private init(){
        
    }
    
    func storeAccessToken(accessToken: String) {
        let data = Data(accessToken.utf8)
        KeychainHelper.standard.storeItem(data: data, service: "access-token", account: "github")
    }
    
    func retrieveAccessToken() -> String? {
        if let data = KeychainHelper.standard.retrieveItem(service: "access-token", account: "github") {
            return String(data: data, encoding: .utf8)
        } else {
           return nil
        }
    }
    
}
