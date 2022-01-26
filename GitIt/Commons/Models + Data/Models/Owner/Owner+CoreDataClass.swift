//
//  Owner+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 04/01/2022.
//
//

import Foundation
import CoreData

public class Owner: NSManagedObject {

    convenience init(from ownerModel: OwnerModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = ownerModel.id
        self.login = ownerModel.login
        self.avatarURL = ownerModel.avatarURL
        self.htmlURL = ownerModel.htmlURL
        self.type = ownerModel.type.rawValue
    }
    
}
