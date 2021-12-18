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
        GithubClient.standard.getRepositoryReadme(fullName: model.fullName, branch: model.defaultBranch) { result in
            switch result {
            case .success(let response): self.model.READMEString = String(data: response, encoding: .utf8)
                                         self.checkIfStarredOrBookmarked(then: handler)
            case .failure(let networkError): handler(.failed(networkError))
            }
        }
    }
    
    func star(then handler: @escaping ViewStateHandler) {
        if !isStarred {
            GithubClient.standard.authenticatedUserStar(fullName: model.fullName) { error in
                guard error != nil else {
                    self.isStarred = true
                    handler(.starred)
                    return
                }
            }
        } else {
            GithubClient.standard.authenticatedUserUnstar(fullName: model.fullName) { error in
                guard error != nil else {
                    self.isStarred = false
                    handler(.starred)
                    return
                }
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
    
    func checkIfStarredOrBookmarked(then handler: @escaping ViewStateHandler) {
        GithubClient.standard.checkAuthenticatedUserDidStar(fullName: model.fullName) { error in
            defer { handler(.presenting) }
            if DataController.standard.exists(self.model) { self.isBookmarked = true }
            guard error != nil else {
                self.isStarred = true
                return
            }
        }
    }
    
}
