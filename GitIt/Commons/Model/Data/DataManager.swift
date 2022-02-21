//
//  DataManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation

class DataManager {
    
    static let standard = DataManager()
    var isSetup: Bool = false
    
    // MARK: - Manager Helpers
    
    let bundlePersistenceProvider = BundlePersistenceProvider()
    let coreDataPersistenceProvider = CoreDataPersistenceProvider()
    let fileManagerPersistenceProvider = FileManagerPersistenceProvider()
    let userDefaultsPersistenceProvider = UserDefaultsPersistenceProvider()
    
    // MARK: Initialisation
    
    private init() {}
    
    // MARK: Setup Methods
    
    func setup(completionHandler: @escaping ((DataError?) -> Void)) {
        isSetup = true
        coreDataPersistenceProvider.setup() { coreDataError in
            if let error = coreDataError {
                completionHandler(.coreData(error))
            } else {
                completionHandler(nil)
            }
        }
        userDefaultsPersistenceProvider.setup()
    }
    
    // MARK: - Save and Load Methods
    
    func saveData() throws {
        do {
            try BookmarksManager.standard.save()
            try SearchHistoryManager.standard.save()
        } catch {
            if let error = error as? CoreDataError {
                throw DataError.coreData(error)
            } else if let error = error as? FileManagerError {
                throw DataError.fileManager(error)
            }
        }
    }
    
    func loadData() throws {
        do {
            try BookmarksManager.standard.load()
            try SearchHistoryManager.standard.load()
        } catch {
            if let error = error as? CoreDataError {
                throw DataError.coreData(error)
            } else if let error = error as? FileManagerError {
                throw DataError.fileManager(error)
            }
        }
    }
    
    // MARK: - Clear Methods
    
    // Clears stored data without removing UserDefaults keys
    func clearData() throws {
        isSetup = false
        do {
            // Clear data stored in Memory
            try BookmarksManager.standard.clearAll()
            SearchHistoryManager.standard.clearAll()
            
            // Clear data stored in Storage
            try coreDataPersistenceProvider.clear()
            fileManagerPersistenceProvider.clear()
        } catch let error as CoreDataError {
            throw DataError.coreData(error)
        }
    }
    
    // Clears all stored data including UserDefaults keys
    func clearAllData() throws {
        isSetup = false
        do {
            // Clear data stored in Memory
            try BookmarksManager.standard.clearAll()
            SearchHistoryManager.standard.clearAll()
            
            // Clear data stored in Storage
            try coreDataPersistenceProvider.clear()
            fileManagerPersistenceProvider.clear()
            userDefaultsPersistenceProvider.clear()
        } catch let error as CoreDataError {
            throw DataError.coreData(error)
        }
    }
    
}
