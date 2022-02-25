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
    var handler: NetworkLoadingHandler?
    
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
    }
    
    init(collectionCellViewModel: OrganizationCollectionCellViewModel) {
        logicController = OrganizationDetailLogicController(withParameter: collectionCellViewModel.login)
    }
    
    init(tableCellViewModel: OrganizationTableCellViewModel) {
        logicController = OrganizationDetailLogicController(withParameter: tableCellViewModel.login)
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
    
    // MARK: - Status Checking Method
    
    func checkForStatus() async -> Array<Bool> {
        let status = await logicController.checkForStatus()
        isBookmarked = status[0]
        return status
    }
    
    // MARK: - Synchronize Method
    
    func synchronize() {
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
