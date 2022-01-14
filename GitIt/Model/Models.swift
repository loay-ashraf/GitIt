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
    var isComplete: Bool { get set }
    
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
    var isComplete: Bool
    
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
        isComplete = false
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
        isComplete = false
    }
    
    init(from user: User) {
        self.id = user.id
        self.login = user.login!
        self.avatarURL = user.avatarURL
        self.htmlURL = user.htmlURL
        self.name = user.name
        self.bio = user.bio
        self.company = user.company
        self.location = user.location
        self.blogURL = user.blogURL
        self.email = user.email
        self.twitter = user.twitter
        self.repositories = user.repositories
        self.followers = user.followers
        self.following = user.following
        isComplete = true
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
    var isComplete: Bool
    
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
        isComplete = false
    }
    
    init(from repository: Repository) {
        self.id = repository.id
        self.name = repository.name
        self.fullName = repository.fullName
        self.owner = OwnerModel(from: repository.owner)
        self.htmlURL = repository.htmlURL
        self.description = repository.overview
        self.homepageURL = repository.homepageURL
        self.language = repository.language
        self.stars = repository.stars
        self.forks = repository.forks
        self.defaultBranch = repository.defaultBranch
        self.READMEString = repository.readmeString
        isComplete = true
    }
    
}

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

struct CommitModel: Model {
    
    let id: Int
    let message: String
    let htmlURL: URL
    let author: OwnerModel?
    var isComplete: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case commit
        case htmlURL = "html_url"
        case author

    }
    
    enum CommitCodingKeys: String, CodingKey {
        
        case message
    
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        id = 0
        message = try nestedContainer.decode(String.self, forKey: .message)
        htmlURL = try container.decode(URL.self, forKey: .htmlURL)
        author = try? container.decode(OwnerModel.self, forKey: .author)
        isComplete = true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = container.nestedContainer(keyedBy: CommitCodingKeys.self, forKey: .commit)
        try nestedContainer.encode(message, forKey: .message)
        try container.encode(htmlURL, forKey: .htmlURL)
        try container.encode(author, forKey: .author)
    }
    
}

struct OrganizationModel: Model {
    
    let id: Int
    let login: String
    let avatarURL: URL
    let htmlURL: URL
    let name: String?
    let description: String?
    let location: String?
    let blogURL: URL?
    let email: String?
    let twitter: String?
    let repositories: Int?
    var isComplete: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case name
        case description
        case location
        case blogURL = "blog"
        case email
        case twitter = "twitter_username"
        case repositories = "public_repos"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        login = try container.decode(String.self, forKey: .login)
        avatarURL = try container.decode(URL.self, forKey: .avatarURL)
        htmlURL = try container.decodeIfPresent(URL.self, forKey: .htmlURL) ?? URL(string: "https://github.com/orgs/\(login)")!
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        blogURL = try? container.decodeIfPresent(URL.self, forKey: .blogURL)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        twitter = try container.decodeIfPresent(String.self, forKey: .twitter)
        repositories = try container.decodeIfPresent(Int.self, forKey: .repositories)
        isComplete = false
    }
    
    init(from owner: OwnerModel) {
        self.id = owner.id
        self.login = owner.login
        self.avatarURL = owner.avatarURL
        self.htmlURL = owner.htmlURL
        name = nil
        description = nil
        location = nil
        blogURL = nil
        email = nil
        twitter = nil
        repositories = nil
        isComplete = false
    }
    
    init(from organization: Organization) {
        self.id = organization.id
        self.login = organization.login
        self.avatarURL = organization.avatarURL
        self.htmlURL = organization.htmlURL
        self.name = organization.name
        self.description = organization.overview
        self.location = organization.location
        self.blogURL = organization.blogURL
        self.email = organization.email
        self.twitter = organization.twitter
        self.repositories = organization.repositories
        isComplete = true
    }
    
}
