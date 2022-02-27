//
//  Organization+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import CoreData
import RealmSwift

@objc(Organization)
public class Organization: NSManagedObject {

    convenience init(from organizationModel: OrganizationModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = organizationModel.id
        self.login = organizationModel.login
        self.avatarURL = organizationModel.avatarURL
        self.htmlURL = organizationModel.htmlURL
        self.name = organizationModel.name
        self.overview = organizationModel.description
        self.location = organizationModel.location
        self.blogURL = organizationModel.blogURL
        self.email = organizationModel.email
        self.twitter = organizationModel.twitter
        self.repositories = organizationModel.repositories ?? 0
    }
    
}

class OrganizationBookmark: Object {
    
    @Persisted var avatarURL: String
    @Persisted var blogURL: String?
    @Persisted var email: String?
    @Persisted var htmlURL: String
    @Persisted(primaryKey: true) var id: Int
    @Persisted var location: String?
    @Persisted var login: String
    @Persisted var name: String?
    @Persisted var overview: String?
    @Persisted var repositories: Int
    @Persisted var twitter: String?
    
    convenience init(from organizationModel: OrganizationModel) {
        self.init()
        self.id = organizationModel.id
        self.login = organizationModel.login
        self.avatarURL = organizationModel.avatarURL.absoluteString
        self.htmlURL = organizationModel.htmlURL.absoluteString
        self.name = organizationModel.name
        self.overview = organizationModel.description
        self.location = organizationModel.location
        self.blogURL = organizationModel.blogURL?.absoluteString
        self.email = organizationModel.email
        self.twitter = organizationModel.twitter
        self.repositories = organizationModel.repositories ?? 0
    }
    
}
