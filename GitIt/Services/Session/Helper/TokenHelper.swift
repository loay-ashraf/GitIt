//
//  TokenHelper.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation

class TokenHelper {
    
    func storeToken(accessToken: String?) -> Error? {
        var data: Data
        if let accessToken = accessToken {
            data = Data(accessToken.utf8)
        } else {
            data = Data("".utf8)
        }
        return KeychainManager.standard.storeItem(data: data, service: "access-token", account: "github")
    }
    
    func retrieveToken() -> Result<String,Error> {
        let result = KeychainManager.standard.retrieveItem(service: "access-token", account: "github")
        switch result {
        case .success(let data): return .success(String(data: data, encoding: .utf8)!)
        case .failure(let error): return.failure(error)
        }
    }
    
}
