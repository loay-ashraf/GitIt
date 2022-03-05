//
//  BookmarksLogicControllerProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 04/01/2022.
//

import Foundation

protocol BookmarksLogicController: DataPersistenceLogicController where DataPersistenceManagerType == BookmarksManager { }

extension BookmarksLogicController {
    
    // MARK: - Model Manipulation Methods
    
    func add(model: ModelType) {
       return
    }
    
    func delete(model: ModelType) {
        return
    }

    func clear() {
        Task {
            await MainActor.run { try? dataPersistenceManager.clearActive() }
        }
    }
    
}
