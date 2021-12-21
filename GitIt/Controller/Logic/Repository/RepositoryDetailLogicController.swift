//
//  RepositoryDetailLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/11/2021.
//

import Foundation

class RepositoryDetailLogicController {
    
    var model: RepositoryModel
    var isBookmarked: Bool = false
    var isStarred: Bool = false
    
    typealias ViewStateHandler = (RepositoryDetailViewState) -> Void
    
    // MARK: - Initialisation
    
    init(_ model: RepositoryModel) {
        self.model = model
    }
    
    // MARK: - Business Logic Methods
    
    func load(then handler: @escaping ViewStateHandler) {
        loadREADME(then: handler)
    }
    
    func loadREADME(then handler: @escaping ViewStateHandler) {
        NetworkClient.standard.getRepositoryReadme(fullName: model.fullName, branch: model.defaultBranch) { result in
            switch result {
            case .success(let response): self.model.READMEString = String(data: response, encoding: .utf8)
                                         self.checkIfStarredOrBookmarked(then: handler)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }
    
    func star(then handler: @escaping ViewStateHandler) {
        if !isStarred {
            NetworkClient.standard.authenticatedUserStar(fullName: model.fullName) { error in
                guard error != nil else {
                    self.isStarred = true
                    handler(.starred)
                    return
                }
            }
        } else {
            NetworkClient.standard.authenticatedUserUnstar(fullName: model.fullName) { error in
                guard error != nil else {
                    self.isStarred = false
                    handler(.starred)
                    return
                }
            }
        }
    }
    
    func bookmark(then handler: @escaping ViewStateHandler) {
        defer { handler(.bookmarked) }
        if !isBookmarked {
            guard CoreDataManager.standard.insert(model) != nil else {
                isBookmarked = true
                return
            }
        } else {
            guard CoreDataManager.standard.delete(model) != nil else {
                isBookmarked = false
                return
            }
        }
    }
    
    func checkIfStarredOrBookmarked(then handler: @escaping ViewStateHandler) {
        NetworkClient.standard.checkAuthenticatedUserDidStar(fullName: model.fullName) { error in
            defer { handler(.presenting) }
            let fetchResult = CoreDataManager.standard.exists(self.model)
            switch fetchResult {
            case .success(let exists): self.isBookmarked = exists
            case .failure(_): self.isBookmarked = false
            }
            guard error != nil else {
                self.isStarred = true
                return
            }
        }
    }
    
}
