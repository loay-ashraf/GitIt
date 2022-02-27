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
        self.modelArray.removeAll { return $0 == model }
    }

    func clear() {
        Task {
            await MainActor.run { try? dataPersistenceManager.clearActive() }
        }
    }
    
}
