//
//  Owner+CoreDataProperties.swift
//  
//
//  Created by Loay Ashraf on 04/01/2022.
//
//

import Foundation
import CoreData

extension Owner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Owner> {
        return NSFetchRequest<Owner>(entityName: "Owner")
    }

    @NSManaged public var id: Int
    @NSManaged public var login: String
    @NSManaged public var avatarURL: URL
    @NSManaged public var htmlURL: URL
    @NSManaged public var type: String

}
