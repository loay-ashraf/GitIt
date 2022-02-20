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
    
    let bundleHelper = BundleHelper()
    let coreDataHelper = CoreDataHelper()
    let fileManagerHelper = FileManagerHelper()
    let userDefaultsHelper = UserDefaultsHelper()
    
    // MARK: Initialisation
    
    private init() {}
    
    // MARK: Setup Methods
    
    func setup(completionHandler: @escaping ((DataError?) -> Void)) {
        isSetup = true
        coreDataHelper.setup() { coreDataError in
            if let error = coreDataError {
                completionHandler(.coreData(error))
            } else {
                completionHandler(nil)
            }
        }
        userDefaultsHelper.setup()
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
            try coreDataHelper.clear()
            fileManagerHelper.clear()
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
            try coreDataHelper.clear()
            fileManagerHelper.clear()
            userDefaultsHelper.clear()
        } catch let error as CoreDataError {
            throw DataError.coreData(error)
        }
    }
    
}
