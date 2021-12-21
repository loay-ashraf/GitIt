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
        defer { handler(.bookmarked) }
        if !isBookmarked {
            guard DataController.standard.insert(model) != nil else {
                isBookmarked = true
                return
            }
        } else {
            guard DataController.standard.delete(model) != nil else {
                isBookmarked = false
                return
            }
        }
    }
    
    func checkIfBookmarked(then handler: @escaping ViewStateHandler) {
        let fetchResult = DataController.standard.exists(self.model)
        switch fetchResult {
        case .success(let exists): self.isBookmarked = exists
        case .failure(_): self.isBookmarked = false
        }
        handler(.presenting)
    }
    
}
