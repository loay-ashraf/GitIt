//
//  UserModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import Foundation

struct UserModel: Model {
    
    typealias CollectionCellViewModelType = UserCollectionCellViewModel
    typealias TableCellViewModelType = UserTableCellViewModel
    
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
    
    init() {
        id = 0
        login = ""
        avatarURL = URL(string: "www.github.com")!
        htmlURL = URL(string: "www.github.com")!
        name = nil
        bio = nil
        company = nil
        location = nil
        blogURL = nil
        email = nil
        twitter = nil
        repositories = nil
        followers = nil
        following = nil
        isComplete = false
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
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        self = collectionCellViewModel.model
    }
    
    init(from tableCellViewModel: TableCellViewModelType) {
        self = tableCellViewModel.model
    }
    
    init(from owner: OwnerModel) {
        id = owner.id
        login = owner.login
        avatarURL = owner.avatarURL
        htmlURL = owner.htmlURL
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
        id = user.id
        login = user.login!
        avatarURL = user.avatarURL
        htmlURL = user.htmlURL
        name = user.name
        bio = user.bio
        company = user.company
        location = user.location
        blogURL = user.blogURL
        email = user.email
        twitter = user.twitter
        repositories = user.repositories
        followers = user.followers
        following = user.following
        isComplete = true
    }
    
}
