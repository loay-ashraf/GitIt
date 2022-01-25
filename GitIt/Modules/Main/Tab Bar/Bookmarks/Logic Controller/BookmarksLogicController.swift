//
//  BookmarksLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/01/2022.
//

import Foundation

class BookmarksLogicController {
    
    var userModel = [UserModel]()
    var repositoryModel = [RepositoryModel]()
    var organizationModel = [OrganizationModel]()
    
    var bookmarksManager = BookmarksManager.standard
    var bookmarksContext: BookmarksContext! {
        get { return bookmarksManager.activeBookmarksContext }
        set { bookmarksManager.activeBookmarksContext = newValue }
    }
    
    func load(then handler: LoadingHandler) {
        switch bookmarksContext {
        case .users: loadUser(then: handler)
        case .repositories: loadRepository(then: handler)
        case .organizations: loadOrganization(then: handler)
        default: break
        }
    }
    
    private func loadUser(then handler: LoadingHandler) {
        let userBookmarks = bookmarksManager.getUsers()!
        userModel.removeAll()
        for bookmark in userBookmarks {
            userModel.append(UserModel(from: bookmark))
        }
        handler(nil)
    }
    
    private func loadRepository(then handler: LoadingHandler) {
        let repositoryBookmarks = bookmarksManager.getRepositories()!
        repositoryModel.removeAll()
        for bookmark in repositoryBookmarks {
            repositoryModel.append(RepositoryModel(from: bookmark))
        }
        handler(nil)
    }
    
    private func loadOrganization(then handler: LoadingHandler) {
        let organizationBookmarks = bookmarksManager.getOrganizations()!
        organizationModel.removeAll()
        for bookmark in organizationBookmarks {
            organizationModel.append(OrganizationModel(from: bookmark))
        }
        handler(nil)
    }
    
    func clear() {
        try? bookmarksManager.clearActive()
        switch bookmarksContext {
        case .users: userModel.removeAll()
        case .repositories: repositoryModel.removeAll()
        case .organizations: organizationModel.removeAll()
        default: break
        }
    }
    
}