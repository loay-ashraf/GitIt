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
        bindToModel()
    }
    
    init(collectionCellViewModel: RepositoryCollectionCellViewModel) {
        let fullName = collectionCellViewModel.owner.login.appendPathComponent(collectionCellViewModel.name)
        logicController = RepositoryDetailLogicController(withParameter: fullName)
        bindToModel()
    }
    
    init(tableCellViewModel: RepositoryTableCellViewModel) {
        let fullName = tableCellViewModel.owner.login.appendPathComponent(tableCellViewModel.name)
        logicController = RepositoryDetailLogicController(withParameter: fullName)
        bindToModel()
    }

    // MARK: - View Actions
    
    func toggleBookmark() -> Bool {
        if !isBookmarked {
            isBookmarked = logicController.bookmark()
        } else {
            isBookmarked = !logicController.unBookmark()
        }
        return isBookmarked
    }
    
    func toggleStar() async -> Bool {
        if !isStarred{
            isStarred = await logicController.star()
        } else {
            isStarred = await !logicController.unStar()
        }
        return isStarred
    }
    
    // MARK: - Status Checking Method
    
    func checkForStatus() async -> Array<Bool> {
        let status = await logicController.checkForStatus()
        isBookmarked = status[0]
        isStarred = status[1]
        return status
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] modelObject in
            if let modelObject = modelObject {
                self?.name = modelObject.name
                self?.fullName = modelObject.fullName
                self?.owner = modelObject.owner
                self?.htmlURL = modelObject.htmlURL
                self?.description = modelObject.description
                self?.homepageURL = modelObject.homepageURL
                self?.language = modelObject.language
                self?.stars = modelObject.stars
                self?.forks = modelObject.forks
                self?.defaultBranch = modelObject.defaultBranch
                self?.license = modelObject.license
                self?.READMEString = modelObject.READMEString
            }
        }
    }
    
}
