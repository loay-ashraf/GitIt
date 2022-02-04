//
//  RepositoryModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import Foundation

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
    let license: LicenseModel?
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
        case license
        
    }
    
    init() {
        id = 0
        name = ""
        fullName = ""
        owner = OwnerModel()
        htmlURL = URL(string: "www.github.com")!
        description = nil
        homepageURL = nil
        language = nil
        stars = 0
        forks = 0
        defaultBranch = ""
        license = nil
        isComplete = false
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
        license = try? values.decode(LicenseModel.self, forKey: .license)
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
        self.license = LicenseModel(from: repository.license)
        self.READMEString = repository.readmeString
        isComplete = true
    }
    
}
