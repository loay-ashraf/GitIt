//
//  User+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import CoreData

public class User: NSManagedObject {
    
    convenience init(form userModel: UserModel, in context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = userModel.id
        self.login = userModel.login
        self.avatarURL = userModel.avatarURL
        self.htmlURL = userModel.htmlURL
        self.name = userModel.name
        self.bio = userModel.bio
        self.company = userModel.company
        self.location = userModel.location
        self.blogURL = userModel.blogURL
        self.twitter = userModel.twitter
        self.email = userModel.email
        self.followers = userModel.followers ?? 0
        self.following = userModel.following ?? 0
        self.repositories = userModel.repositories ?? 0
    }
    
}
