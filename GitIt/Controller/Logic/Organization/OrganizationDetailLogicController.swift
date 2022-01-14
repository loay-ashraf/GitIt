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
        if !model.isComplete {
            NetworkClient.standard.getOrganization(organizationLogin: model.login) { result in
                switch result {
                case .success(let response): self.model = response
                                             self.model.isComplete = true
                                             self.checkIfBookmarked(then: handler, then: bookmarkHandler)
                case .failure(let networkError): handler(networkError)
                }
            }
        } else {
            checkIfBookmarked(then: handler, then: bookmarkHandler)
        }
    }
    
    func bookmark(then handler: @escaping BookmarkActionHandler) {
        defer { handler(isBookmarked) }
        if !isBookmarked {
            if let _ = try? BookmarksManager.standard.add(model: model) {
                isBookmarked = true
            }
        } else {
            if let _ = try? BookmarksManager.standard.delete(model: model) {
                isBookmarked = false
            }
        }
    }
    
    func checkIfBookmarked(then handler: @escaping ErrorHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        let fetchResult = BookmarksManager.standard.check(model: self.model)
        switch fetchResult {
        case true: self.isBookmarked = true
                                   bookmarkHandler(self.isBookmarked)
        case false: self.isBookmarked = false
        default: break
        }
        handler(nil)
    }
    
}
