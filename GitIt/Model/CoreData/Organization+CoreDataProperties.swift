//
//  Organization+CoreDataProperties.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import CoreData

extension Organization {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Organization> {
        return NSFetchRequest<Organization>(entityName: "Organization")
    }

    @NSManaged public var avatarURL: URL
    @NSManaged public var blogURL: URL?
    @NSManaged public var email: String?
    @NSManaged public var htmlURL: URL
    @NSManaged public var id: Int
    @NSManaged public var location: String?
    @NSManaged public var login: String
    @NSManaged public var name: String?
    @NSManaged public var overview: String?
    @NSManaged public var repositories: Int
    @NSManaged public var twitter: String?

}
