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
