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
    var model = Observable<OrganizationModel>()
    var parameter = String()
    
    // MARK: - Fetch Data Method
    
    func fetchData() async -> Result<OrganizationModel,NetworkError> {
        await webServiceClient.fetchOrganization(organizationLogin: parameter)
    }
    
    // MARK: - (Un)Bookmark Methods
    
    @MainActor func bookmark() -> Bool {
        if let _ = try? BookmarksManager.standard.add(model: modelObject) {
            return true
        }
        return false
    }
    
    @MainActor func unBookmark() -> Bool {
        if let _ = try? BookmarksManager.standard.delete(model: modelObject) {
            return true
        }
        return false
    }
    
    // MARK: - Check For Status Methods
    
    func checkForStatus() async -> Array<Bool> {
        let fetchResult = await BookmarksManager.standard.check(model: modelObject)
        switch fetchResult {
        case true: return [true]
        case false: return [false]
        default: return [false]
        }
    }
    
}
