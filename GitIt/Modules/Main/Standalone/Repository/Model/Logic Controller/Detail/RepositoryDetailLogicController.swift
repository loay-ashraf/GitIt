//
//  RepositoryDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import Foundation

final class RepositoryDetailLogicController: WebServiceDetailLogicController {
    
    // MARK: - Properties
    
    typealias WebServiceClientType = GitHubClient
    typealias ModelType = RepositoryModel
    
    var webServiceClient = GitHubClient()
    var model = RepositoryModel()
    var parameter = String()
    var handler: NetworkLoadingHandler?
    
    // MARK: - Fetch Data Methods
    
    func fetchData() {
        webServiceClient.fetchRepository(fullName: parameter, completionHandler: processFetchResult(result:))
    }
    
    func fetchREADME() {
        webServiceClient.downloadRepositoryREADME(fullName: model.fullName, branch: model.defaultBranch) { result in
            switch result {
            case .success(let response): self.model.READMEString = String(data: response, encoding: .utf8)
                                         self.model.isComplete = true
                                         self.handler?(nil)
            case .failure(let networkError): self.handler?(networkError)
            }
        }
    }
    
    // MARK: - Fetch Result Processing Method
    
    func processFetchResult(result: Result<ModelType, NetworkError>) {
        switch result {
        case .success(let response): self.model = response
                                     self.fetchREADME()
        case .failure(let networkError): handler?(networkError)
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
    
    // MARK: - (Un)Star Methods
    
    func star(then handler: @escaping () -> Void) {
        webServiceClient.starRepository(fullName: model.fullName) { error in
            guard error != nil else {
                handler()
                return
            }
        }
    }
    
    func unStar(then handler: @escaping () -> Void) {
        webServiceClient.unStarRepository(fullName: model.fullName) { error in
            guard error != nil else {
                handler()
                return
            }
        }
    }
    
    // MARK: - Check For Status Methods
    
    func checkForStatus(then handler: @escaping ([Bool]) -> Void) {
        if NetworkManager.standard.isReachable, SessionManager.standard.sessionType == .authenticated {
            checkIfStarred { isStarred in
                let isBookmarked = self.checkIfBookmarked()
                handler([isBookmarked,isStarred])
            }
        } else {
            let isBookmarked = self.checkIfBookmarked()
            handler([isBookmarked,false])
        }
    }

    func checkIfBookmarked() -> Bool {
        let fetchResult = BookmarksManager.standard.check(model: model)
        switch fetchResult {
        case true: return true
        case false: return false
        default: return false
        }
    }
    
    func checkIfStarred(then handler: @escaping (Bool) -> Void) {
        webServiceClient.checkIfStarredRepository(fullName: model.fullName) { error in
            guard error != nil else {
                handler(true)
                return
            }
            handler(false)
        }
    }
    
}
