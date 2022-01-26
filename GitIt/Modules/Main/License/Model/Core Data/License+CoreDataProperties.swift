//
//  License+CoreDataProperties.swift
//  
//
//  Created by Loay Ashraf on 25/01/2022.
//
//

import Foundation
import CoreData


extension License {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<License> {
        return NSFetchRequest<License>(entityName: "License")
    }

    @NSManaged public var key: String
    @NSManaged public var name: String
    @NSManaged public var url: URL

}
