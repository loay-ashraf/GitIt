//
//  Repository+CoreDataProperties.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import CoreData

extension Repository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repository> {
        return NSFetchRequest<Repository>(entityName: "Repository")
    }

    @NSManaged public var defaultBranch: String
    @NSManaged public var forks: Int
    @NSManaged public var fullName: String
    @NSManaged public var homepageURL: URL?
    @NSManaged public var htmlURL: URL
    @NSManaged public var id: Int
    @NSManaged public var language: String?
    @NSManaged public var name: String
    @NSManaged public var overview: String?
    @NSManaged public var stars: Int
    @NSManaged public var readmeString: String?
    @NSManaged public var owner: Owner
    @NSManaged public var license: License?

}
