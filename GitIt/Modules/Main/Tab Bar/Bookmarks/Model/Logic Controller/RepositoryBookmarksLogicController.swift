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
    var model = Array<RepositoryModel>()
    
    // MARK: - Initialization
    
    init() {
        dataPersistenceManager.activeBookmarksContext = .repositories
        synchronize()
    }
    
    // MARK: - Model Synchronize Method
    
    func synchronize() {
        if let bookmarksArray = dataPersistenceManager.getRepositories() {
            model = bookmarksArray.map { return RepositoryModel(from: $0) }
        }
    }
    
}
