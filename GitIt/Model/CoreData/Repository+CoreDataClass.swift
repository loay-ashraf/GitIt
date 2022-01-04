//
//  Repository+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import CoreData

@objc(Repository)
public class Repository: NSManagedObject {

    convenience init(from repositoryModel: RepositoryModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = repositoryModel.id
        self.name = repositoryModel.name
        self.fullName = repositoryModel.fullName
        self.owner = Owner(from: repositoryModel.owner, in: context)
        self.htmlURL = repositoryModel.htmlURL
        self.overview = repositoryModel.description
        self.homepageURL = repositoryModel.homepageURL
        self.language = repositoryModel.language
        self.stars = repositoryModel.stars
        self.forks = repositoryModel.forks
        self.defaultBranch = repositoryModel.defaultBranch
        self.readmeString = repositoryModel.READMEString
    }
    
}
