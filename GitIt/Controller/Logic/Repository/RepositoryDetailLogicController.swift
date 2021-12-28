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
    
    typealias StarActionHandler = (Bool) -> Void
    typealias BookmarkActionHandler = (Bool) -> Void
    typealias READMEHandler = (NetworkError?) -> Void
    
    // MARK: - Initialisation
    
    init(_ model: RepositoryModel) {
        self.model = model
    }
    
    // MARK: - Business Logic Methods
    
    func load(then handler: @escaping ErrorHandler, then starHandler: @escaping StarActionHandler, then bookmarkHandler: @escaping BookmarkActionHandler, then readmeHandler: @escaping READMEHandler) {
        checkIfStarredOrBookmarked(then: handler, then: starHandler, then: bookmarkHandler)
        loadREADME(then: readmeHandler)
    }
    
    func loadREADME(then readmeHandler: @escaping READMEHandler) {
        NetworkClient.standard.getRepositoryReadme(fullName: model.fullName, branch: model.defaultBranch) { result in
            switch result {
            case .success(let response): self.model.READMEString = String(data: response, encoding: .utf8); readmeHandler(nil)
            case .failure(let networkError): readmeHandler(networkError)
            }
        }
    }
    
    func star(then handler: @escaping StarActionHandler) {
        if !isStarred {
            NetworkClient.standard.authenticatedUserStar(fullName: model.fullName) { error in
                guard error != nil else {
                    self.isStarred = true
                    handler(self.isStarred)
                    return
                }
            }
        } else {
            NetworkClient.standard.authenticatedUserUnstar(fullName: model.fullName) { error in
                guard error != nil else {
                    self.isStarred = false
                    handler(self.isStarred)
                    return
                }
            }
        }
    }
    
    func bookmark(then handler: @escaping BookmarkActionHandler) {
        defer { handler(isBookmarked) }
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
    
    func checkIfStarredOrBookmarked(then handler: @escaping ErrorHandler, then starHandler: @escaping StarActionHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        NetworkClient.standard.checkAuthenticatedUserDidStar(fullName: model.fullName) { error in
            defer { handler(nil) }
            let fetchResult = CoreDataManager.standard.exists(self.model)
            switch fetchResult {
            case .success(let exists): self.isBookmarked = exists
                                       bookmarkHandler(self.isBookmarked)
            case .failure(_): self.isBookmarked = false
            }
            guard error != nil else {
                self.isStarred = true
                starHandler(self.isStarred)
                return
            }
        }
    }
    
}
