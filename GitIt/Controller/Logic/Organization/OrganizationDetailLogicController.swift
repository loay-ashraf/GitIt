//
//  OrganizationDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import Foundation

class OrganizationDetailLogicController {
    
    var model: OrganizationModel
    var isBookmarked: Bool = false
    
    typealias ViewStateHandler = (OrganizationDetailViewState) -> Void
    
    // MARK: - Initialisation
    
    init(_ model: OrganizationModel) {
        self.model = model
    }
    
    // MARK: - Business Logic Methods
    
    func load(then handler: @escaping ViewStateHandler) {
        GithubClient.standard.getOrganization(organizationLogin: model.login) { response, error in
            self.model = response!
            self.checkIfBookmarked(then: handler)
        }
    }
    
    func bookmark(then handler: @escaping ViewStateHandler) {
        if !isBookmarked {
            DataController.standard.insert(model)
            isBookmarked = true
        } else {
            DataController.standard.delete(model)
            isBookmarked = false
        }
        handler(.bookmarked)
    }
    
    func checkIfBookmarked(then handler: @escaping ViewStateHandler) {
        if DataController.standard.exists(self.model) { self.isBookmarked = true }
        handler(.presenting)
    }
    
}
