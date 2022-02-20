//
//  OrganizationDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 15/12/2021.
//

import Foundation

final class OrganizationDetailLogicController: WebServiceDetailLogicController {
    
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = OrganizationModel
    
    var webServiceClient = GitHubClient()
    var model = OrganizationModel()
    var parameter = String()
    var handler: NetworkLoadingHandler?
    
    // MARK: - Fetch Data Method
    
    func fetchData() {
        webServiceClient.fetchOrganization(organizationLogin: parameter, completionHandler: processFetchResult(result:))
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
    
    // MARK: - Check For Status Methods
    
    func checkForStatus(then handler: @escaping ([Bool]) -> Void) {
        let fetchResult = BookmarksManager.standard.check(model: model)
        switch fetchResult {
        case true: handler([true])
        case false: handler([false])
        default: handler([false])
        }
    }
    
}
