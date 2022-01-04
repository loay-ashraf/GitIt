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
    
    typealias FollowActionHandler = (Bool) -> Void
    typealias BookmarkActionHandler = (Bool) -> Void
    
    // MARK: - Initialisation
    
    init(_ model: UserModel) {
        self.model = model
    }
    
    // MARK: - Business Logic Methods
    
    func load(then handler: @escaping ErrorHandler, then followHandler: @escaping FollowActionHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        NetworkClient.standard.getUser(userLogin: model.login) { result in
            switch result {
            case .success(let response): self.model = response
                                         self.checkIfFollowedOrBookmarked(then: handler, then: followHandler, then: bookmarkHandler)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    func follow(then handler: @escaping FollowActionHandler) {
        if !isFollowed {
            NetworkClient.standard.authenticatedUserFollow(userLogin: model.login) { error in
                guard error != nil else {
                    self.isFollowed = true
                    handler(self.isFollowed)
                    return
                }
            }
        } else {
            NetworkClient.standard.authenticatedUserUnfollow(userLogin: model.login) { error in
                guard error != nil else {
                    self.isFollowed = false
                    handler(self.isFollowed)
                    return
                }
            }
        }
    }
    
    func bookmark(then handler: @escaping BookmarkActionHandler) {
        defer { handler(isBookmarked) }
        if !isBookmarked {
            guard BookmarksManager.standard.addBookmark(model: model) != nil else {
                isBookmarked = true
                return
            }
        } else {
            guard BookmarksManager.standard.deleteBookmark(model: model) != nil else {
                isBookmarked = false
                return
            }
        }
    }
    
    func checkIfFollowedOrBookmarked(then handler: @escaping ErrorHandler, then followHandler: @escaping FollowActionHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        NetworkClient.standard.checkAuthenticatedUserIsFollowing(userLogin: model.login) { error in
            defer { handler(nil) }
            let fetchResult = CoreDataManager.standard.exists(self.model)
            switch fetchResult {
            case .success(let exists): self.isBookmarked = exists
                                       bookmarkHandler(self.isBookmarked)
            case .failure(_): self.isBookmarked = false
            }
            guard error != nil else {
                self.isFollowed = true
                followHandler(self.isFollowed)
                return
            }
        }
    }
    
}
