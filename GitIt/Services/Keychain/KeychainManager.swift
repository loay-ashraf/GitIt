//
//  KeychainManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 02/11/2021.
//

import Foundation

class KeychainManager {
    
    static let standard = KeychainManager()
    
    private init() {}
    
    func storeItem(data: Data, service: String, account: String) -> Error? {
        let query = [kSecValueData: data,
                    kSecClass: kSecClassGenericPassword,
                    kSecAttrService: service,
                    kSecAttrAccount: account,
                    ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                let query = [kSecAttrService: service,
                            kSecAttrAccount: account,
                            kSecClass: kSecClassGenericPassword,
                            ] as CFDictionary

                let attributesToUpdate = [kSecValueData: data] as CFDictionary
                let status = SecItemUpdate(query, attributesToUpdate)
                guard status == errSecSuccess else {
                    let error = NSError(domain: "", code: Int(status), userInfo: nil) as Error
                    return error
                }
                return nil
            }
            let error = NSError(domain: "", code: Int(status), userInfo: nil) as Error
            return error
        }
        return nil
    }
    
    func retrieveItem(service: String, account: String) -> Result<Data,Error> {
        let query = [kSecAttrService: service,
                    kSecAttrAccount: account,
                    kSecClass: kSecClassGenericPassword,
                    kSecReturnData: true
                    ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess else {
            let error = NSError(domain: "", code: Int(status), userInfo: nil) as Error
            return .failure(error)
        }
            
        return .success((result as! Data))
    }
    
}
