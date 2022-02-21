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
    var model = Array<UserModel>()
    
    // MARK: - Initialization
    
    init() {
        dataPersistenceManager.activeBookmarksContext = .users
        synchronize()
    }
    
    // MARK: - Model Synchronize Method
    
    func synchronize() {
        if let bookmarksArray = dataPersistenceManager.getUsers() {
            model = bookmarksArray.map { return UserModel(from: $0) }
        }
    }
    
}
