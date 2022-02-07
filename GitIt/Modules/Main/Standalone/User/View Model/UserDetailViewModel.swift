//
//  UserDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

class UserDetailViewModel {
    
    // MARK: - Properties
    
    var logicController: UserDetailLogicController
    
    var login: String = ""
    var avatarURL: URL = URL(string: "www.github.com")!
    var htmlURL: URL = URL(string: "www.github.com")!
    var name: String?
    var bio: String?
    var company: String?
    var location: String?
    var blogURL: URL?
    var email: String?
    var twitter: String?
    var repositories: Int = 0
    var followers: Int = 0
    var following: Int = 0
    var isBookmarked: Bool = false
    var isFollowed: Bool = false
    
    // MARK: - Initialization
    
    init(login: String) {
        logicController = UserDetailLogicController(login: login)
    }
    
    init(collectionCellViewModel: UserCollectionCellViewModel) {
        logicController = UserDetailLogicController(login: collectionCellViewModel.login)
    }
    
    init(tableCellViewModel: UserTableCellViewModel) {
        logicController = UserDetailLogicController(login: tableCellViewModel.login)
    }
    
    init(model: UserModel) {
        logicController = UserDetailLogicController(model: model)
    }
    
    // MARK: - View Actions
    
    func toggleBookmark(then handler: @escaping () -> Void) {
        if !isBookmarked {
            logicController.bookmark { [weak self] in
                self?.isBookmarked = true
                handler()
            }
        } else {
            logicController.unBookmark { [weak self] in
                self?.isBookmarked = false
                handler()
            }
        }
    }
    
    func toggleFollow(then handler: @escaping () -> Void) {
        if !isFollowed {
            logicController.follow { [weak self] in
                self?.isFollowed = true
                handler()
            }
        } else {
            logicController.unFollow { [weak self] in
                self?.isFollowed = false
                handler()
            }
        }
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.checkIfBookmarkedOrFollowed { isBookmarked, isFollowed in
                    self?.isBookmarked = isBookmarked
                    self?.isFollowed = isFollowed
                    self?.synchronizeModel()
                    handler(nil)
                }
            }
        }
    }
    
    // MARK: - Status Checking Methods
    
    func checkIfBookmarkedOrFollowed(then handler: @escaping (Bool,Bool) -> Void) {
        logicController.checkIfBookmarkedOrFollowed(then: handler)
    }
    
    // MARK: - Model Synchronization Methods
    
    private func synchronizeModel() {
        let model = logicController.model
        login = model.login
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        name = model.name
        bio = model.bio
        company = model.company
        location = model.location
        blogURL = model.blogURL
        email = model.email
        twitter = model.twitter
        repositories = model.repositories!
        followers = model.followers!
        following = model.following!
    }
    
}
