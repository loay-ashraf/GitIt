//
//  OwnerModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import Foundation

struct OwnerModel: Model {
    
    let id: Int
    let login: String
    let avatarURL: URL
    let htmlURL: URL
    let type: OwnerType
    var isComplete: Bool
    
    enum OwnerType: String, Codable {
        
        case user = "User"
        case organization = "Organization"
        
    }
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case type
        
    }
    
    init() {
        id = 0
        login = ""
        avatarURL = URL(string: "www.github.com")!
        htmlURL = URL(string: "www.github.com")!
        type = .user
        isComplete = false
    }
    
    init(id: Int, login: String, avatarURL: URL, htmURL: URL, type: OwnerType) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.htmlURL = htmURL
        self.type = type
        isComplete = true
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        login = try container.decode(String.self, forKey: .login)
        avatarURL = try container.decode(URL.self, forKey: .avatarURL)
        htmlURL = try container.decode(URL.self, forKey: .htmlURL)
        type = try container.decode(OwnerType.self, forKey: .type)
        isComplete = true
    }
    
    init(from owner: Owner) {
        self.id = owner.id
        self.login = owner.login
        self.avatarURL = owner.avatarURL
        self.htmlURL = owner.htmlURL
        self.type = OwnerType(rawValue: owner.type)!
        isComplete = true
    }
    
}
