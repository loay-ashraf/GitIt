//
//  UserDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/11/2021.
//

import Foundation

class UserDetailLogicController {
    
    var model: UserModel
    var isBookmarked: Bool = false
    var isFollowed: Bool = false
    
    typealias ViewStateHandler = (UserDetailViewState) -> Void
    
    // MARK: - Initialisation
    
    init(_ model: UserModel) {
        self.model = model
    }
    
    // MARK: - Business Logic Methods
    
    func load(then handler: @escaping ViewStateHandler) {
        GitClient.standard.getUser(userLogin: model.login) { response, error in
            self.model = response!
            self.checkIfFollowedOrBookmarked(then: handler)
        }
    }
    
    func follow(then handler: @escaping ViewStateHandler) {
        if !isFollowed {
            GitClient.standard.authenticatedUserFollow(userLogin: model.login) { error in
                guard error != nil else {
                    self.isFollowed = true
                    handler(.followed)
                    return
                }
            }
        } else {
            GitClient.standard.authenticatedUserUnfollow(userLogin: model.login) { error in
                guard error != nil else {
                    self.isFollowed = false
                    handler(.followed)
                    return
                }
            }
        }
    }
    
    func bookmark(then handler: @escaping ViewStateHandler) {
        if !isBookmarked {
            DataController.standard.insert(model)
            isBookmarked = true
        } else {
            DataController.standard.delete(model)
            isBookmarked = false
        }
        handler(.bookmarked)
    }
    
    func checkIfFollowedOrBookmarked(then handler: @escaping ViewStateHandler) {
        GitClient.standard.checkAuthenticatedUserIsFollowing(userLogin: model.login) { error in
            defer { handler(.presenting) }
            if DataController.standard.exists(self.model) { self.isBookmarked = true }
            guard error != nil else {
                self.isFollowed = true
                return
            }
        }
    }
    
}
