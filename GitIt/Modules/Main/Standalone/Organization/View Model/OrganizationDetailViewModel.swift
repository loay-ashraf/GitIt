//
//  OrganizationDetailViewModel.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/02/2022.
//

import Foundation

final class OrganizationDetailViewModel: WebServiceDetailViewModel {

    // MARK: - Properties
    
    typealias WebServiceLogicControllerType = OrganizationDetailLogicController
    
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
    
    init(withParameter parameter: String) {
        logicController = OrganizationDetailLogicController(withParameter: parameter)
        bindToModel()
    }
    
    init(collectionCellViewModel: OrganizationCollectionCellViewModel) {
        logicController = OrganizationDetailLogicController(withParameter: collectionCellViewModel.login)
        bindToModel()
    }
    
    init(tableCellViewModel: OrganizationTableCellViewModel) {
        logicController = OrganizationDetailLogicController(withParameter: tableCellViewModel.login)
        bindToModel()
    }
    
    // MARK: - View Actions
    
    @MainActor func toggleBookmark() -> Bool {
        if !isBookmarked {
            isBookmarked = logicController.bookmark()
        } else {
            isBookmarked = !logicController.unBookmark()
        }
        return isBookmarked
    }
    
    // MARK: - Status Checking Method
    
    func checkForStatus() async -> Array<Bool> {
        let status = await logicController.checkForStatus()
        isBookmarked = status[0]
        return status
    }
    
    // MARK: - Bind to Model Method
    
    func bindToModel() {
        logicController.bind { [weak self] modelObject in
            if let modelObject = modelObject {
                self?.login = modelObject.login
                self?.avatarURL = modelObject.avatarURL
                self?.htmlURL = modelObject.htmlURL
                self?.name = modelObject.name
                self?.description = modelObject.description
                self?.location = modelObject.location
                self?.blogURL = modelObject.blogURL
                self?.email = modelObject.email
                self?.twitter = modelObject.twitter
                self?.repositories = modelObject.repositories!
            }
        }
    }
    
}
