//
//  Organization+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import CoreData

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
