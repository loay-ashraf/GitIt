//
//  OrganizationDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

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
    
    init(collectionCellViewModel: OrganizationCollectionCellViewModel) {
        logicController = OrganizationDetailLogicController(login: collectionCellViewModel.login)
    }
    
    init(tableCellViewModel: OrganizationTableCellViewModel) {
        logicController = OrganizationDetailLogicController(login: tableCellViewModel.login)
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
    
    func showMembers() {
        let membersVC = UserViewController.instatiate(context: .members(organizationLogin: login) as UserContext)
        NavigationRouter.push(viewController: membersVC)
    }
    
    func showRepositories() {
        let repositoriesVC = RepositoryViewController.instatiate(context: .user(userLogin: login, numberOfRepositories: repositories) as RepositoryContext)
        NavigationRouter.push(viewController: repositoriesVC)
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
