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
    
    func load(then handler: @escaping LoadingHandler, then starHandler: @escaping StarActionHandler, then bookmarkHandler: @escaping BookmarkActionHandler, then readmeHandler: @escaping READMEHandler) {
        if !model.isComplete {
            checkIfStarredOrBookmarked(then: handler, then: starHandler, then: bookmarkHandler)
            loadREADME(then: readmeHandler)
        } else {
            checkIfStarredOrBookmarked(then: handler, then: starHandler, then: bookmarkHandler)
            readmeHandler(nil)
        }
    }
    
    func loadREADME(then readmeHandler: @escaping READMEHandler) {
        GitHubClient.downloadRepositoryREADME(fullName: model.fullName, branch: model.defaultBranch) { result in
            switch result {
            case .success(let response): self.model.READMEString = String(data: response, encoding: .utf8); readmeHandler(nil)
                                         self.model.isComplete = true
            case .failure(let networkError): readmeHandler(networkError)
            }
        }
    }
    
    func star(then handler: @escaping StarActionHandler) {
        if !isStarred {
            GitHubClient.starRepository(fullName: model.fullName) { error in
                guard error != nil else {
                    self.isStarred = true
                    handler(self.isStarred)
                    return
                }
            }
        } else {
            GitHubClient.unStarRepository(fullName: model.fullName) { error in
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
            if let _ = try? BookmarksManager.standard.add(model: model) {
                isBookmarked = true
            }
        } else {
            if let _ = try? BookmarksManager.standard.delete(model: model) {
                isBookmarked = false
            }
        }
    }
    
    func checkIfStarredOrBookmarked(then handler: @escaping LoadingHandler, then starHandler: @escaping StarActionHandler, then bookmarkHandler: @escaping BookmarkActionHandler) {
        GitHubClient.checkIfStarredRepository(fullName: model.fullName) { error in
            defer { handler(nil) }
            let fetchResult = BookmarksManager.standard.check(model: self.model)
            switch fetchResult {
            case true: self.isBookmarked = true
                       bookmarkHandler(self.isBookmarked)
            case false: self.isBookmarked = false
            default: break
            }
            guard error != nil else {
                self.isStarred = true
                starHandler(self.isStarred)
                return
            }
        }
    }
    
}
