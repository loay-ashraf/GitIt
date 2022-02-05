//
//  RepositoryDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation
import UIKit

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
        URLHelper.openURL(htmlURL)
    }
    
    func share() {
        URLHelper.shareURL(htmlURL)
    }
    
    func showOwner(navigationController: UINavigationController?) {
        if owner.type == .user {
            let userLogin = owner.login
            let userDetailVC = UserDetailViewController.instatiate(parameter: userLogin)
            navigationController?.pushViewController(userDetailVC, animated: true)
        } else if owner.type == .organization {
            let organizationLogin = owner.login
            let organizationDetailVC = OrganizationDetailViewController.instatiate(parameter: organizationLogin)
            navigationController?.pushViewController(organizationDetailVC, animated: true)
        }
    }
    
    func goToHomepage() {
        URLHelper.openURL(homepageURL!)
    }
    
    func showStars(navigationController: UINavigationController?) {
        let starsVC = UserViewController.instatiate(context: .stargazers(repositoryFullName: fullName, numberOfStargazers: stars) as UserContext)
        navigationController?.pushViewController(starsVC, animated: true)
    }
    
    func showForks(navigationController: UINavigationController?) {
        let forksVC = RepositoryViewController.instatiate(context: .forks(repositoryFullName: fullName, numberOfForks: forks) as RepositoryContext)
        navigationController?.pushViewController(forksVC, animated: true)
    }
    
    func showContributors(navigationController: UINavigationController?) {
        let contributorsVC = UserViewController.instatiate(context: .contributors(repositoryFullName: fullName) as UserContext)
        navigationController?.pushViewController(contributorsVC, animated: true)
    }
    
    func showCommits(navigationController: UINavigationController?) {
        let commitsVC = CommitViewController.instatiate(parameter: fullName)
        navigationController?.pushViewController(commitsVC, animated: true)
    }
    
    func showLicense(navigationController: UINavigationController?) {
        let licenseVC = LicenseViewController.instatiate(parameters: [fullName,defaultBranch])
        navigationController?.pushViewController(licenseVC, animated: true)
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
