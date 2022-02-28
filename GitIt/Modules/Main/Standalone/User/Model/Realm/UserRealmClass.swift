//
//  UserRealmClass.swift
//  
//
//  Created by Loay Ashraf on 03/01/2022.
//
//

import Foundation
import RealmSwift

class UserBookmark: Object {
    
    // MARK: - Properties
    
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
    
    // MARK: - Initialization
    
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
