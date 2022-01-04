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

    typealias BookmarkActionHandler = (Bool) -> Void
    
    // MARK: - Initialisation
    
    init(_ model: OrganizationModel) {
        self.model = model
    }
    
    // MARK: - Business Logic Methods
    
    func load(then handler: @escaping ErrorHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        NetworkClient.standard.getOrganization(organizationLogin: model.login) { result in
            switch result {
            case .success(let response): self.model = response
                                         self.checkIfBookmarked(then: handler, then: bookmarkHandler)
            case .failure(let networkError): handler(networkError)
            }
        }
    }
    
    func bookmark(then handler: @escaping BookmarkActionHandler) {
        defer { handler(isBookmarked) }
        if !isBookmarked {
            guard BookmarksManager.standard.addBookmark(model: model) != nil else {
                isBookmarked = true
                return
            }
        } else {
            guard BookmarksManager.standard.deleteBookmark(model: model) != nil else {
                isBookmarked = false
                return
            }
        }
    }
    
    func checkIfBookmarked(then handler: @escaping ErrorHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        let fetchResult = CoreDataManager.standard.exists(self.model)
        switch fetchResult {
        case .success(let exists): self.isBookmarked = exists
                                   bookmarkHandler(self.isBookmarked)
        case .failure(_): self.isBookmarked = false
        }
        handler(nil)
    }
    
}
