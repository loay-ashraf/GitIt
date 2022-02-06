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
    
    func bookmarkAction(then handler: @escaping () -> Void) {
        if !isBookmarked {
            logicController.bookmark(then: handler)
        } else {
            logicController.unBookmark(then: handler)
        }
    }
    
    func followAction(then handler: @escaping () -> Void) {
        if !isFollowed {
            logicController.follow(then: handler)
        } else {
            logicController.unFollow(then: handler)
        }
    }
    
    func openInSafari() {
        URLHelper.openWebsite(htmlURL)
    }
    
    func share() {
        URLHelper.shareWebsite(htmlURL)
    }
    
    func goToBlog() {
        URLHelper.openWebsite(blogURL!)
    }
    
    func composeMail() {
        URLHelper.openMail(email!)
    }
    
    func goToTwitter() {
        URLHelper.openTwitter(twitter!)
    }
    
    func showFollowers() {
        let followersVC = UserViewController.instatiate(context: .followers(userLogin: login, numberOfFollowers: followers) as UserContext)
        NavigationRouter.push(viewController: followersVC)
    }
    
    func showFollowing() {
        let followingVC = UserViewController.instatiate(context: .following(userLogin: login, numberOfFollowing: following) as UserContext)
        NavigationRouter.push(viewController: followingVC)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController.instatiate(context: .user(userLogin: login, numberOfRepositories: repositories) as RepositoryContext)
        NavigationRouter.push(viewController: repositoriesVC)
    }
    
    func showOrganizations() {
        let organizationsVC = OrganizationViewController.instatiate(context: .user(userLogin: login) as OrganizationContext)
        NavigationRouter.push(viewController: organizationsVC)
    }
    
    func showStarred() {
        let repositoriesVC = RepositoryViewController.instatiate(context: .starred(userLogin: login) as RepositoryContext)
        NavigationRouter.push(viewController: repositoriesVC)
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
