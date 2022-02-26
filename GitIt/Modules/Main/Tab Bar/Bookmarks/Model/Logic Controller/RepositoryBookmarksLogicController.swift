//
//  RepositoryBookmarksLogicController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

final class RepositoryBookmarksLogicController: BookmarksLogicController {
   
    // MARK: - Properties
    
    typealias ModelType = RepositoryModel
    
    var dataPersistenceManager = BookmarksManager.standard
    var model = Observable<Array<RepositoryModel>>()
    
    // MARK: - Initialization
    
    init() {
        bindToPersistedData()
    }
    
    // MARK: - Bind to Persisted Data Method

    func bindToPersistedData() {
        dataPersistenceManager.bindRepositories { [weak self] repositoryBookmarks in
            if let repositoryBookmarks = repositoryBookmarks {
                self?.modelArray = repositoryBookmarks.map { return RepositoryModel(from: $0) }
            }
        }
    }
    
}
