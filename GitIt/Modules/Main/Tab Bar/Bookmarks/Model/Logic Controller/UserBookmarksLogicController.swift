//
//  UserBookmarksLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class UserBookmarksLogicController: BookmarksLogicController {
   
    // MARK: - Properties
    
    typealias ModelType = UserModel
    
    var dataPersistenceManager = BookmarksManager.standard
    var model = Observable<Array<UserModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToPersistedData()
    }
    
    // MARK: - Bind to Persisted Data Method

    func bindToPersistedData() {
        dataPersistenceManager.bindUsers { [weak self] userBookmarks in
            if let userBookmarks = userBookmarks {
                self?.modelArray = userBookmarks.map { return UserModel(from: $0) }
            }
        }
    }
    
}
