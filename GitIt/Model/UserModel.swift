//
//  UserModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/11/2021.
//

import Foundation
import UIKit

protocol Model: Codable, Equatable {
    
    var id: Int { get }
    var htmlURL: URL { get }
    
}

protocol DetailViewController: UIViewController {
    
    static var identifier: String { get } 
    static func instatiateFromStoryBoard<Type: Model>(with model: Type) -> UIViewController
    
}

struct UserModel: Model {
    
    let id: Int
    let login: String
    let avatarURL: URL
    let htmlURL: URL
    let name: String?
    let bio: String?
    let company: String?
    let location: String?
    let blogURL: URL?
    let email: String?
    let twitter: String?
    let repositories: Int?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case name
        case bio
        case company
        case location
        case blogURL = "blog"
        case email
        case twitter = "twitter_username"
        case repositories = "public_repos"
        case followers
        case following
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        login = try values.decode(String.self, forKey: .login)
        avatarURL = try values.decode(URL.self, forKey: .avatarURL)
        htmlURL = try values.decode(URL.self, forKey: .htmlURL)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        blogURL = try? values.decodeIfPresent(URL.self, forKey: .blogURL)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        twitter = try values.decodeIfPresent(String.self, forKey: .twitter)
        repositories = try values.decodeIfPresent(Int.self, forKey: .repositories)
        followers = try values.decodeIfPresent(Int.self, forKey: .followers)
        following = try values.decodeIfPresent(Int.self, forKey: .following)
    }
    
}

struct SearchHistory<Type: Model>: Codable {
    
    var models: [Type]
    var keywords: [String]
    
    init() {
        models = []
        keywords = []
    }
    
}
