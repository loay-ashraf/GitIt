//
//  RepositoryDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import Foundation

class RepositoryDetailLogicController {
    
    // MARK: - Properties
    
    var fullName = String()
    var model = RepositoryModel()
    
    // MARK: - Initialization
    
    init(fullName: String) {
        self.fullName = fullName
    }
    
    init(model: RepositoryModel) {
        self.model = model
    }
    
    // MARK: - Loading Methods
    
    func load(then handler: @escaping LoadingHandler) {
        if !fullName.isEmpty, !model.isComplete {
            GitHubClient.fetchRepository(fullName: fullName) { result in
                switch result {
                case .success(let response): self.model = response
                                             self.loadREADME(then: handler)
                case .failure(let networkError): handler(networkError)
                }
            }
        } else {
            handler(nil)
        }
    }
    
    func loadREADME(then handler: @escaping LoadingHandler) {
        GitHubClient.downloadRepositoryREADME(fullName: model.fullName, branch: model.defaultBranch) { result in
            switch result {
            case .success(let response): self.model.READMEString = String(data: response, encoding: .utf8)
                                         self.model.isComplete = true
                                         handler(nil)
            case .failure(let networkError): handler(networkError)
            }
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
        GitHubClient.starRepository(fullName: model.fullName) { error in
            guard error != nil else {
                handler()
                return
            }
        }
    }
    
    func unStar(then handler: @escaping () -> Void) {
        GitHubClient.unStarRepository(fullName: model.fullName) { error in
            guard error != nil else {
                handler()
                return
            }
        }
    }
    
    // MARK: - Status Checking Methods
    
    func checkIfBookmarkedOrStarred(then handler: @escaping (Bool,Bool) -> Void) {
        if NetworkManager.standard.isReachable, SessionManager.standard.sessionType == .authenticated {
            checkIfStarred { isStarred in
                let isBookmarked = self.checkIfBookmarked()
                handler(isBookmarked,isStarred)
            }
        } else {
            let isBookmarked = self.checkIfBookmarked()
            handler(isBookmarked,false)
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
        GitHubClient.checkIfStarredRepository(fullName: model.fullName) { error in
            guard error != nil else {
                handler(true)
                return
            }
            handler(false)
        }
    }
    
}
