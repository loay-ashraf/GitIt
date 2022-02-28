//
//  RepositoryRealmClass.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import RealmSwift

class RepositoryBookmark: Object {
    
    // MARK: - Properties
    
    @Persisted var defaultBranch: String
    @Persisted var forks: Int
    @Persisted var fullName: String
    @Persisted var homepageURL: String?
    @Persisted var htmlURL: String
    @Persisted(primaryKey: true) var id: Int
    @Persisted var language: String?
    @Persisted var name: String
    @Persisted var overview: String?
    @Persisted var stars: Int
    @Persisted var readmeString: String?
    @Persisted var owner: OwnerBookmark?
    @Persisted var license: LicenseBookmark?
    
    // MARK: - Initialization
    
    convenience init(from repositoryModel: RepositoryModel) {
        self.init()
        self.id = repositoryModel.id
        self.name = repositoryModel.name
        self.fullName = repositoryModel.fullName
        self.owner = OwnerBookmark(from: repositoryModel.owner)
        self.htmlURL = repositoryModel.htmlURL.absoluteString
        self.overview = repositoryModel.description
        self.homepageURL = repositoryModel.homepageURL?.absoluteString
        self.language = repositoryModel.language
        self.stars = repositoryModel.stars
        self.forks = repositoryModel.forks
        self.defaultBranch = repositoryModel.defaultBranch
        self.license = LicenseBookmark(from: repositoryModel.license)
        self.readmeString = repositoryModel.READMEString
    }
    
}
