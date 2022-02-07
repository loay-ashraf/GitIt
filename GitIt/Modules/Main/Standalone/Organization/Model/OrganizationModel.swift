//
//  OrganizationModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import Foundation

struct OrganizationModel: Model {
    
    typealias CollectionCellViewModelType = OrganizationCollectionCellViewModel
    typealias TableCellViewModelType = OrganizationTableCellViewModel
    
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
    
    init() {
        id = 0
        login = ""
        avatarURL = URL(string: "www.github.com")!
        htmlURL = URL(string: "www.github.com")!
        name = nil
        description = nil
        location = nil
        blogURL = nil
        email = nil
        twitter = nil
        repositories = nil
        isComplete = false
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
    
    init(from collectionCellViewModel: CollectionCellViewModelType) {
        self = collectionCellViewModel.model
    }
    
    init(from tableCellViewModel: TableCellViewModelType) {
        self = tableCellViewModel.model
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
