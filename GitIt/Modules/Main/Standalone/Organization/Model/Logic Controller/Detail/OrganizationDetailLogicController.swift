//
//  OrganizationDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import Foundation

class OrganizationDetailLogicController {
    
    // MARK: - Properties
    
    var login = String()
    var model = OrganizationModel()
    
    // MARK: - Initialization
    
    init(login: String) {
        self.login = login
    }
    
    init(model: OrganizationModel) {
        self.model = model
    }
    
    // MARK: - Business Logic Methods
    
    func load(then handler: @escaping LoadingHandler) {
        if !login.isEmpty, !model.isComplete {
            GitHubClient.fetchOrganization(organizationLogin: login) { result in
                switch result {
                case .success(let response): self.model = response
                                             self.model.isComplete = true
                                             handler(nil)
                case .failure(let networkError): handler(networkError)
                }
            }
        } else {
            handler(nil)
        }
    }
    
    // MARK: - (Un)Bookmark Methods
    
    func bookmark(then handler: @escaping () -> Void) {
        if let _ = try? BookmarksManager.standard.add(model: model) {
            handler()
        }
    }
    
    func unBookmark(then handler: @escaping () -> Void) {
        if let _ = try? BookmarksManager.standard.delete(model: model) {
            handler()
        }
    }
    
    // MARK: - Status Checking Methods
    
    func checkIfBookmarked(then handler: @escaping (Bool) -> Void) {
        let fetchResult = BookmarksManager.standard.check(model: model)
        switch fetchResult {
        case true: handler(true)
        case false: handler(false)
        default: handler(false)
        }
    }
    
}
