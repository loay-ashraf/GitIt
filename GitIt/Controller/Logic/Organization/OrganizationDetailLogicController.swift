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
        NetworkClient.standard.getOrganization(organizationLogin: model.login) { result in
            switch result {
            case .success(let response): self.model = response
                                         self.checkIfBookmarked(then: handler)
            case .failure(let networkError): handler(.failed(networkError))
            }
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
