//
//  UserDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/11/2021.
//

import Foundation

class UserDetailLogicController {
    
    // MARK: - Properties
    
    var login = String()
    var model = UserModel()
    
    // MARK: - Initialization

    init(login: String) {
        self.login = login
    }
    
    init(model: UserModel) {
        self.model = model
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        if !login.isEmpty, !model.isComplete {
            GitHubClient.fetchUser(userLogin: login) { result in
                switch result {
                case .success(let response): self.model = response
                                             self.model.isComplete = true
                                             handler(nil)
                case .failure(let networkError): handler(networkError)
                }
            }
        } else {
            handler(nil)
        }
    }
    
    // MARK: - (Un)Bookmark Methods
    
    func bookmark(then handler: @escaping () -> Void) {
        if let _ = try? BookmarksManager.standard.add(model: model) {
            handler()
        }
    }
    
    func unBookmark(then handler: @escaping () -> Void) {
        if let _ = try? BookmarksManager.standard.delete(model: model) {
            handler()
        }
    }
    
    // MARK: - (Un)Follow Methods
    
    func follow(then handler: @escaping () -> Void) {
        GitHubClient.followUser(userLogin: model.login) { error in
            guard error != nil else {
                handler()
                return
            }
        }
    }
    
    func unFollow(then handler: @escaping () -> Void) {
        GitHubClient.unFollowUser(userLogin: model.login) { error in
            guard error != nil else {
                handler()
                return
            }
        }
    }
    
    // MARK: - Status Checking Methods
    
    func checkIfBookmarkedOrFollowed(then handler: @escaping (Bool,Bool) -> Void) {
        if NetworkManager.standard.isReachable, SessionManager.standard.sessionType == .authenticated {
            checkIfFollowed { isFollowed in
                let isBookmarked = self.checkIfBookmarked()
                handler(isBookmarked,isFollowed)
            }
        } else {
            let isBookmarked = self.checkIfBookmarked()
            handler(isBookmarked,false)
        }
    }
    
    func checkIfBookmarked() -> Bool {
        let fetchResult = BookmarksManager.standard.check(model: model)
        switch fetchResult {
        case true: return true
        case false: return false
        default: return false
        }
    }
    
    func checkIfFollowed(then handler: @escaping (Bool) -> Void) {
        GitHubClient.checkIfFollowingUser(userLogin: model.login) { error in
            guard error != nil else {
                handler(true)
                return
            }
            handler(false)
        }
    }
    
}
