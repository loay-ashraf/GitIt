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
        NetworkClient.standard.getUser(userLogin: model.login) { result in
            switch result {
            case .success(let response): self.model = response
                                         self.checkIfFollowedOrBookmarked(then: handler)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }
    
    func follow(then handler: @escaping ViewStateHandler) {
        if !isFollowed {
            NetworkClient.standard.authenticatedUserFollow(userLogin: model.login) { error in
                guard error != nil else {
                    self.isFollowed = true
                    handler(.followed)
                    return
                }
            }
        } else {
            NetworkClient.standard.authenticatedUserUnfollow(userLogin: model.login) { error in
                guard error != nil else {
                    self.isFollowed = false
                    handler(.followed)
                    return
                }
            }
        }
    }
    
    func bookmark(then handler: @escaping ViewStateHandler) {
        defer { handler(.bookmarked) }
        if !isBookmarked {
            guard DataController.standard.insert(model) != nil else {
                isBookmarked = true
                return
            }
        } else {
            guard DataController.standard.delete(model) != nil else {
                isBookmarked = false
                return
            }
        }
    }
    
    func checkIfFollowedOrBookmarked(then handler: @escaping ViewStateHandler) {
        NetworkClient.standard.checkAuthenticatedUserIsFollowing(userLogin: model.login) { error in
            defer { handler(.presenting) }
            let fetchResult = DataController.standard.exists(self.model)
            switch fetchResult {
            case .success(let exists): self.isBookmarked = exists
            case .failure(_): self.isBookmarked = false
            }
            guard error != nil else {
                self.isFollowed = true
                return
            }
        }
    }
    
}
