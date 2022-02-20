//
//  RepositoryDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

final class RepositoryDetailViewModel: WebServiceDetailViewModel {

    // MARK: - Properties
    
    typealias WebServiceLogicControllerType = RepositoryDetailLogicController
    
    var logicController: RepositoryDetailLogicController
    var handler: NetworkLoadingHandler?
    
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
    
    init(withParameter parameter: String) {
        logicController = RepositoryDetailLogicController(withParameter: parameter)
    }
    
    init(collectionCellViewModel: RepositoryCollectionCellViewModel) {
        let fullName = collectionCellViewModel.owner.login.appendPathComponent(collectionCellViewModel.name)
        logicController = RepositoryDetailLogicController(withParameter: fullName)
    }
    
    init(tableCellViewModel: RepositoryTableCellViewModel) {
        let fullName = tableCellViewModel.owner.login.appendPathComponent(tableCellViewModel.name)
        logicController = RepositoryDetailLogicController(withParameter: fullName)
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
    
    func toggleStar(then handler: @escaping () -> Void) {
        if !isStarred{
            logicController.star { [weak self] in
                self?.isStarred = true
                handler()
            }
        } else {
            logicController.unStar { [weak self] in
                self?.isStarred = false
                handler()
            }
        }
    }
    
    // MARK: - Status Checking Method
    
    func checkForStatus() {
        logicController.checkForStatus { status in
            self.isBookmarked = status[0]
            self.isStarred = status[1]
            self.handler?(nil)
        }
    }
    
    // MARK: - Synchronize Method
    
    func synchronize() {
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
