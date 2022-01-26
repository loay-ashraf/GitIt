//
//  LicenseModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 25/01/2022.
//

import Foundation

struct LicenseModel: Codable, Equatable {
    
    let key: String
    let name: String
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        
        case key
        case name
        case url
        
    }
    
    init?(from license: License?) {
        if let license = license {
            self.key = license.key
            self.name = license.key
            self.url = license.url
        } else {
            return nil
        }
    }
    
}
