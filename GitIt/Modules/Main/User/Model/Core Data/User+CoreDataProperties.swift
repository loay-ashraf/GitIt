//
//  User+CoreDataProperties.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatarURL: URL
    @NSManaged public var bio: String?
    @NSManaged public var blogURL: URL?
    @NSManaged public var company: String?
    @NSManaged public var email: String?
    @NSManaged public var followers: Int
    @NSManaged public var following: Int
    @NSManaged public var htmlURL: URL
    @NSManaged public var id: Int
    @NSManaged public var location: String?
    @NSManaged public var login: String?
    @NSManaged public var name: String?
    @NSManaged public var repositories: Int
    @NSManaged public var twitter: String?

}
