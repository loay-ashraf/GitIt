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
    
    func load(then handler: @escaping LoadingHandler, then followHandler: @escaping FollowActionHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        if !model.isComplete {
            GitHubClient.fetchUser(userLogin: model.login) { result in
                switch result {
                case .success(let response): self.model = response
                                             self.model.isComplete = true
                                             self.checkIfFollowedOrBookmarked(then: handler, then: followHandler, then: bookmarkHandler)
                case .failure(let networkError): handler(networkError)
                }
            }
        } else {
            checkIfFollowedOrBookmarked(then: handler, then: followHandler, then: bookmarkHandler)
        }
    }
    
    func follow(then handler: @escaping FollowActionHandler) {
        if !isFollowed {
            GitHubClient.followUser(userLogin: model.login) { error in
                guard error != nil else {
                    self.isFollowed = true
                    handler(self.isFollowed)
                    return
                }
            }
        } else {
            GitHubClient.unFollowUser(userLogin: model.login) { error in
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
            if let _ = try? BookmarksManager.standard.add(model: model) {
                isBookmarked = true
            }
        } else {
            if let _ = try? BookmarksManager.standard.delete(model: model) {
                isBookmarked = false
            }
        }
    }
    
    func checkIfFollowedOrBookmarked(then handler: @escaping LoadingHandler, then followHandler: @escaping FollowActionHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        if NetworkManager.standard.isReachable && SessionManager.standard.sessionType == .authenticated {
            GitHubClient.checkIfFollowingUser(userLogin: model.login) { error in
                defer { handler(nil) }
                let fetchResult = BookmarksManager.standard.check(model: self.model)
                switch fetchResult {
                case true: self.isBookmarked = true
                            bookmarkHandler(self.isBookmarked)
                case false: self.isBookmarked = false
                default: break
                }
                guard error != nil else {
                    self.isFollowed = true
                    followHandler(self.isFollowed)
                    return
                }
            }
        } else {
            let fetchResult = BookmarksManager.standard.check(model: self.model)
            switch fetchResult {
            case true: self.isBookmarked = true
                        bookmarkHandler(self.isBookmarked)
            case false: self.isBookmarked = false
            default: break
            }
            handler(nil)
        }
    }
    
}
