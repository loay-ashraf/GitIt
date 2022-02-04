//
//  OrganizationDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation
import UIKit

class OrganizationDetailViewModel {
    
    // MARK: - Properties
    
    var logicController: OrganizationDetailLogicController
    
    var login: String = ""
    var avatarURL: URL = URL(string: "www.github.com")!
    var htmlURL: URL = URL(string: "www.github.com")!
    var name: String?
    var description: String?
    var location: String?
    var blogURL: URL?
    var email: String?
    var twitter: String?
    var repositories: Int = 0
    var isBookmarked: Bool = false
    
    // MARK: - Initialization
    
    init(login: String) {
        logicController = OrganizationDetailLogicController(login: login)
    }
    
    init(cellViewModel: OrganizationCellViewModel) {
        logicController = OrganizationDetailLogicController(login: cellViewModel.login)
    }
    
    init(model: OrganizationModel) {
        logicController = OrganizationDetailLogicController(model: model)
    }
    
    // MARK: - View Actions
    
    func bookmarkAction(then handler: @escaping () -> Void) {
        if !isBookmarked {
            logicController.bookmark(then: handler)
        } else {
            logicController.unBookmark(then: handler)
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
    
    func showMembers(navigationController: UINavigationController?) {
        let repositoriesVC = UserViewController.instatiate(context: .members(organizationLogin: login) as UserContext)
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
    func showRepositories(navigationController: UINavigationController?) {
        let repositoriesVC = RepositoryViewController.instatiate(context: .user(userLogin: login, numberOfRepositories: repositories) as RepositoryContext)
        navigationController?.pushViewController(repositoriesVC, animated: true)
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.checkIfBookmarkedOrFollowed { isBookmarked in
                    self?.isBookmarked = isBookmarked
                    self?.synchronizeModel()
                    handler(nil)
                }
            }
        }
    }
    
    // MARK: - Status Checking Methods
    
    func checkIfBookmarkedOrFollowed(then handler: @escaping (Bool) -> Void) {
        logicController.checkIfBookmarked(then: handler)
    }
    
    // MARK: - Model Synchronization Methods
    
    private func synchronizeModel() {
        let model = logicController.model
        login = model.login
        avatarURL = model.avatarURL
        htmlURL = model.htmlURL
        name = model.name
        description = model.description
        location = model.location
        blogURL = model.blogURL
        email = model.email
        twitter = model.twitter
        repositories = model.repositories!
    }
    
}
