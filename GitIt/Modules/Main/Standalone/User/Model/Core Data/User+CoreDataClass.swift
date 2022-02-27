//
//  User+CoreDataClass.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import CoreData
import RealmSwift

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

class UserBookmark: Object {
    
    @Persisted var avatarURL: String
    @Persisted var bio: String?
    @Persisted var blogURL: String?
    @Persisted var company: String?
    @Persisted var email: String?
    @Persisted var followers: Int
    @Persisted var following: Int
    @Persisted var htmlURL: String
    @Persisted(primaryKey: true) var id: Int
    @Persisted var location: String?
    @Persisted var login: String?
    @Persisted var name: String?
    @Persisted var repositories: Int
    @Persisted var twitter: String?
    
    convenience init(form userModel: UserModel) {
        self.init()
        self.id = userModel.id
        self.login = userModel.login
        self.avatarURL = userModel.avatarURL.absoluteString
        self.htmlURL = userModel.htmlURL.absoluteString
        self.name = userModel.name
        self.bio = userModel.bio
        self.company = userModel.company
        self.location = userModel.location
        self.blogURL = userModel.blogURL?.absoluteString
        self.twitter = userModel.twitter
        self.email = userModel.email
        self.followers = userModel.followers ?? 0
        self.following = userModel.following ?? 0
        self.repositories = userModel.repositories ?? 0
    }
    
}
