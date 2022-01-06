//
//  BookmarksLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/01/2022.
//

import Foundation

class BookmarksLogicController {
    
    var model = [Any]()
    
    private var modelType: Any.Type?
    
    func load(then handler: LoadingHandler) {
        switch modelType {
        case is UserModel.Type: loadUser(then: handler)
        case is RepositoryModel.Type: loadRepository(then: handler)
        case is OrganizationModel.Type: loadOrganization(then: handler)
        default: break
        }
    }
    
    func setModelType<Type: Model>(modelType: Type.Type) {
        self.modelType = modelType
    }
    
    private func loadUser(then handler: LoadingHandler) {
        let userBookmarks = BookmarksManager.standard.getUserBookmarks()!
        model.removeAll()
        if userBookmarks.isEmpty {
            handler(nil,.bookmarks)
        } else {
            for bookmark in userBookmarks {
                model.append(UserModel(from: bookmark))
            }
            handler(nil,nil)
        }
    }
    
    private func loadRepository(then handler: LoadingHandler) {
        let repositoryBookmarks = BookmarksManager.standard.getRepositoryBookmarks()!
        model.removeAll()
        if repositoryBookmarks.isEmpty {
            handler(nil,.bookmarks)
        } else {
            for bookmark in repositoryBookmarks {
                model.append(RepositoryModel(from: bookmark))
            }
            handler(nil,nil)
        }
    }
    
    private func loadOrganization(then handler: LoadingHandler) {
        let organizationBookmarks = BookmarksManager.standard.getOrganizationBookmarks()!
        model.removeAll()
        if organizationBookmarks.isEmpty {
            handler(nil,.bookmarks)
        } else {
            for bookmark in organizationBookmarks {
                model.append(OrganizationModel(from: bookmark))
            }
            handler(nil,nil)
        }
    }
    
}
