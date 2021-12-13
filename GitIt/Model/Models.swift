//
//  Models.swift
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

protocol StoryboardViewController: UIViewController {
    
    static var storyboardIdentifier: String { get }
    static func instatiateFromStoryboard(with parameters: Any) -> UIViewController
    static func instatiateFromStoryboard<Type: Model>(with model: Type) -> UIViewController
    
}

protocol ReusableTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
    func configure<Type: Model>(with model: Type)
    
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
    
    init(from owner: OwnerModel) {
        self.id = owner.id
        self.login = owner.login
        self.avatarURL = owner.avatarURL
        self.htmlURL = owner.htmlURL
        name = nil
        bio = nil
        company = nil
        location = nil
        blogURL = nil
        email = nil
        twitter = nil
        repositories = nil
        followers = 0
        following = 0
    }
    
}

struct RepositoryModel: Model {
    
    let id: Int
    let name: String
    let fullName: String
    let owner: OwnerModel
    let htmlURL: URL
    let description: String?
    let homepageURL: URL?
    let language: String?
    let stars: Int
    let forks: Int
    let defaultBranch: String
    var READMEString: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case fullName = "full_name"
        case owner
        case htmlURL = "html_url"
        case description
        case homepageURL = "homepage"
        case language
        case stars = "stargazers_count"
        case forks = "forks_count"
        case defaultBranch = "default_branch"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        fullName = try values.decode(String.self, forKey: .fullName)
        owner = try values.decode(OwnerModel.self, forKey: .owner)
        htmlURL = try values.decode(URL.self, forKey: .htmlURL)
        description = try? values.decode(String.self, forKey: .description)
        homepageURL = try? values.decode(URL.self, forKey: .homepageURL)
        language = try? values.decode(String.self, forKey: .language)
        stars = try values.decode(Int.self, forKey: .stars)
        forks = try values.decode(Int.self, forKey: .forks)
        defaultBranch = try values.decode(String.self, forKey: .defaultBranch)
        READMEString = nil
    }
    
}

struct OwnerModel: Model {
    
    let id: Int
    let login: String
    let avatarURL: URL
    let htmlURL: URL
    let type: OwnerType
    
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
    
}

struct OrganizationModel: Model {
    
    let id: Int
    let login: String
    let avatarURL: URL
    let htmlURL: URL
    let name: String?
    let location: String?
    let email: String?
    let twitterUsername: String?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case name
        case location
        case email
        case twitterUsername = "twitter_username"
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
        location = try values.decodeIfPresent(String.self, forKey: .location)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        twitterUsername = try values.decodeIfPresent(String.self, forKey: .twitterUsername)
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
