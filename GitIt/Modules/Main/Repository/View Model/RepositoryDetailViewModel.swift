//
//  RepositoryDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

class RepositoryDetailViewModel {
    
    // MARK: - Properties
    
    var logicController: RepositoryDetailLogicController
    
    var name: String = ""
    var fullName: String = ""
    var owner: OwnerModel = OwnerModel()
    var htmlURL: URL = URL(string: "www.github.com")!
    var description: String?
    var homepageURL: URL?
    var language: String?
    var stars: Int = 0
    var forks: Int = 0
    var defaultBranch: String = ""
    var license: LicenseModel?
    var READMEString: String?
    var isBookmarked: Bool = false
    var isStarred: Bool = false
    
    // MARK: - Initialization
    
    init(fullName: String) {
        logicController = RepositoryDetailLogicController(fullName: fullName)
    }
    
    init(collectionCellViewModel: RepositoryCollectionCellViewModel) {
        let fullName = collectionCellViewModel.owner.login.appendPathComponent(collectionCellViewModel.name)
        logicController = RepositoryDetailLogicController(fullName: fullName)
    }
    
    init(tableCellViewModel: RepositoryTableCellViewModel) {
        let fullName = tableCellViewModel.owner.login.appendPathComponent(tableCellViewModel.name)
        logicController = RepositoryDetailLogicController(fullName: fullName)
    }
    
    init(model: RepositoryModel) {
        logicController = RepositoryDetailLogicController(model: model)
    }
    
    // MARK: - View Actions
    
    func bookmarkAction(then handler: @escaping () -> Void) {
        if !isBookmarked {
            logicController.bookmark(then: handler)
        } else {
            logicController.unBookmark(then: handler)
        }
    }
    
    func starAction(then handler: @escaping () -> Void) {
        if !isStarred{
            logicController.star(then: handler)
        } else {
            logicController.unStar(then: handler)
        }
    }
    
    func openInSafari() {
        URLHelper.openWebsite(htmlURL)
    }
    
    func share() {
        URLHelper.shareWebsite(htmlURL)
    }
    
    func showOwner() {
        if owner.type == .user {
            let userLogin = owner.login
            let userDetailVC = UserDetailViewController.instatiate(parameter: userLogin)
            NavigationRouter.push(viewController: userDetailVC)
        } else if owner.type == .organization {
            let organizationLogin = owner.login
            let organizationDetailVC = OrganizationDetailViewController.instatiate(parameter: organizationLogin)
            NavigationRouter.push(viewController: organizationDetailVC)
        }
    }
    
    func goToHomepage() {
        URLHelper.openWebsite(homepageURL!)
    }
    
    func showStars() {
        let starsVC = UserViewController.instatiate(context: .stargazers(repositoryFullName: fullName, numberOfStargazers: stars) as UserContext)
        NavigationRouter.push(viewController: starsVC)
    }
    
    func showForks() {
        let forksVC = RepositoryViewController.instatiate(context: .forks(repositoryFullName: fullName, numberOfForks: forks) as RepositoryContext)
        NavigationRouter.push(viewController: forksVC)
    }
    
    func showContributors() {
        let contributorsVC = UserViewController.instatiate(context: .contributors(repositoryFullName: fullName) as UserContext)
        NavigationRouter.push(viewController: contributorsVC)
    }
    
    func showCommits() {
        let commitsVC = CommitViewController.instatiate(parameter: fullName)
        NavigationRouter.push(viewController: commitsVC)
    }
    
    func showLicense() {
        let licenseVC = LicenseViewController.instatiate(parameters: [fullName,defaultBranch])
        NavigationRouter.push(viewController: licenseVC)
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        logicController.load { [weak self] error in
            if let error = error {
                handler(error)
            } else {
                self?.checkIfBookmarkedOrStarred { isBookmarked, isStarred in
                    self?.isBookmarked = isBookmarked
                    self?.isStarred = isStarred
                    self?.synchronizeModel()
                    handler(nil)
                }
            }
        }
    }
    
    // MARK: - Status Checking Methods
    
    func checkIfBookmarkedOrStarred(then handler: @escaping (Bool,Bool) -> Void) {
        logicController.checkIfBookmarkedOrStarred(then: handler)
    }
    
    // MARK: - Model Synchronization Methods
    
    private func synchronizeModel() {
        let model = logicController.model
        name = model.name
        fullName = model.fullName
        owner = model.owner
        htmlURL = model.htmlURL
        description = model.description
        homepageURL = model.homepageURL
        language = model.language
        stars = model.stars
        forks = model.forks
        defaultBranch = model.defaultBranch
        license = model.license
        READMEString = model.READMEString
    }
    
}
