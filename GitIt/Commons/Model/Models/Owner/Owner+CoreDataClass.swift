//
//  Owner+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 04/01/2022.
//
//

import Foundation
import CoreData
import RealmSwift

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

class OwnerBookmark: Object {
    
    @Persisted var id: Int
    @Persisted var login: String
    @Persisted var avatarURL: String
    @Persisted var htmlURL: String
    @Persisted var type: String
    
    convenience init(from ownerModel: OwnerModel) {
        self.init()
        self.id = ownerModel.id
        self.login = ownerModel.login
        self.avatarURL = ownerModel.avatarURL.absoluteString
        self.htmlURL = ownerModel.htmlURL.absoluteString
        self.type = ownerModel.type.rawValue
    }
    
}
