//
//  UserDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation
import UIKit

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
    
    init(cellViewModel: UserCellViewModel) {
        logicController = UserDetailLogicController(login: cellViewModel.login)
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
        URLHelper.openURL(htmlURL)
    }
    
    func share() {
        URLHelper.shareURL(htmlURL)
    }
    
    func goToBlog() {
        URLHelper.openURL(blogURL!)
    }
    
    func composeMail() {
        let appURL = URL(string: "mailto://" + email!)!
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        }
    }
    
    func goToTwitter() {
        let appURL = URL(string: "twitter://user?screen_name=" + twitter!)!
        let webURL = URL(string: "https://twitter.com/" + twitter!)!
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            URLHelper.openURL(webURL)
        }
    }
    
    func showFollowers(navigationController: UINavigationController?) {
        let followersVC = UserViewController.instatiate(context: .followers(userLogin: login, numberOfFollowers: followers) as UserContext)
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func showFollowing(navigationController: UINavigationController?) {
        let followingVC = UserViewController.instatiate(context: .following(userLogin: login, numberOfFollowing: following) as UserContext)
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    func showRepositories(navigationController: UINavigationController?) {
        let repositoriesVC = RepositoryViewController.instatiate(context: .user(userLogin: login, numberOfRepositories: repositories) as RepositoryContext)
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
    func showOrganizations(navigationController: UINavigationController?) {
        let organizationsVC = OrganizationViewController.instatiate(context: .user(userLogin: login) as OrganizationContext)
        navigationController?.pushViewController(organizationsVC, animated: true)
    }
    
    func showStarred(navigationController: UINavigationController?) {
        let repositoriesVC = RepositoryViewController.instatiate(context: .starred(userLogin: login) as RepositoryContext)
        navigationController?.pushViewController(repositoriesVC, animated: true)
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
