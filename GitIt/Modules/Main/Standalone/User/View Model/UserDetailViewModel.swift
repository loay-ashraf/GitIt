//
//  UserDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

final class UserDetailViewModel: WebServiceDetailViewModel {
    
    // MARK: - Properties
    
    typealias WebServiceLogicControllerType = UserDetailLogicController
    
    var logicController: UserDetailLogicController
    var handler: NetworkLoadingHandler?
    
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
    
    init(withParameter parameter: String) {
        logicController = UserDetailLogicController(withParameter: parameter)
    }
    
    init(collectionCellViewModel: UserCollectionCellViewModel) {
        logicController = UserDetailLogicController(withParameter: collectionCellViewModel.login)
    }
    
    init(tableCellViewModel: UserTableCellViewModel) {
        logicController = UserDetailLogicController(withParameter: tableCellViewModel.login)
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
    
    // MARK: - Status Checking Method
    
    func checkForStatus() {
        logicController.checkForStatus { status in
            self.isBookmarked = status[0]
            self.isFollowed = status[1]
            self.handler?(nil)
        }
    }
    
    // MARK: - Synchronize Method
    
    func synchronize() {
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
