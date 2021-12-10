//
//  KeychainWrapper.swift
//  GitIt
//
//  Created by Loay Ashraf on 02/11/2021.
//

import Foundation

class KeychainHelper {
    
    static let standard = KeychainHelper()
    
    private init() {}
    
    func storeItem(data: Data, service: String, account: String) {
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
                SecItemUpdate(query, attributesToUpdate)
            } else {
                print("Error: \(status)")
            }
            return
        }
        
    }
    
    func retrieveItem(service: String, account: String) -> Data? {
        let query = [kSecAttrService: service,
                    kSecAttrAccount: account,
                    kSecClass: kSecClassGenericPassword,
                    kSecReturnData: true
                    ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess else {
            print("Error: \(status)")
            return nil
        }
            
        return (result as? Data)
    }
}
