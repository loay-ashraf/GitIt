//
//  LibraryManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation

class LibraryManager {
    
    static let standard = LibraryManager()
    
    var languageColors: [String:String]
    
    private init() {
        let url = Bundle.main.url(forResource: "LanguageColors", withExtension: "json")
        let data = try? Data(contentsOf: url!, options: .mappedIfSafe)
        languageColors = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:String]
    }
    
    // MARK: - Session Property Methods
    
    func setSessionType(sessionType: SessionType) {
        UserDefaults.standard.set(sessionType.rawValue, forKey: "Session Type")
    }
    
    func getSessionType() -> Result<SessionType,LibraryError> {
        if let sessionTypeString = UserDefaults.standard.string(forKey: "Session Type") {
            if let sessionType = SessionType(rawValue: sessionTypeString) {
                return .success(sessionType)
            }
            return .failure(.userDefaults(.unknownPropertyValue))
        } else {
            return .failure(.userDefaults(.propertyNotFound))
        }
    }
    
    // MARK: - Theme Property Methods
    
    func setThemeType(themeType: ThemeType) {
        UserDefaults.standard.set(themeType.rawValue, forKey: "Theme Type")
    }
    
    func getThemeType() -> Result<ThemeType,LibraryError> {
        if let themeTypeString = UserDefaults.standard.string(forKey: "Theme Type") {
            if let themeType = ThemeType(rawValue: themeTypeString) {
                return .success(themeType)
            }
            return .failure(.userDefaults(.unknownPropertyValue))
        } else {
            return .failure(.userDefaults(.propertyNotFound))
        }
    }
    
    // MARK: - Search History Methods
    
    func saveUserSearchHistory(searchHistory: SearchHistory<UserModel>) -> LibraryError? {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        if !fileManager.fileExists(atPath: folderUrl!.path) {
            do {
                try fileManager.createDirectory(atPath: folderUrl!.path, withIntermediateDirectories: false, attributes: [:])
            } catch {
                return .fileManager(.directoryCreationFailed(error))
            }
        }
        let fileUrl = folderUrl?.appendingPathComponent("UserSearchHistory.json")
        var data: Data
        do {
            data = try JSONEncoder().encode(searchHistory)
        } catch {
            return .fileManager(.encodingJSONFailed(error))
        }
        if fileManager.fileExists(atPath: fileUrl!.path) {
            do {
                try data.write(to: fileUrl!)
            } catch {
                return .fileManager(.fileWritingFailed(error))
            }
        } else {
            fileManager.createFile(atPath: fileUrl!.path, contents: data, attributes: [:])
        }
        return nil
    }
    
    func saveRepositorySearchHistory(searchHistory: SearchHistory<RepositoryModel>) -> LibraryError? {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        if !fileManager.fileExists(atPath: folderUrl!.path) {
            do {
                try fileManager.createDirectory(atPath: folderUrl!.path, withIntermediateDirectories: false, attributes: [:])
            } catch {
                return .fileManager(.directoryCreationFailed(error))
            }
        }
        let fileUrl = folderUrl?.appendingPathComponent("RepositorySearchHistory.json")
        var data: Data
        do {
            data = try JSONEncoder().encode(searchHistory)
        } catch {
            return .fileManager(.encodingJSONFailed(error))
        }
        if fileManager.fileExists(atPath: fileUrl!.path) {
            do {
                try data.write(to: fileUrl!)
            } catch {
                return .fileManager(.fileWritingFailed(error))
            }
        } else {
            fileManager.createFile(atPath: fileUrl!.path, contents: data, attributes: [:])
        }
        return nil
    }
    
    func saveOrganizationSearchHistory(searchHistory: SearchHistory<OrganizationModel>) -> LibraryError? {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        if !fileManager.fileExists(atPath: folderUrl!.path) {
            do {
                try fileManager.createDirectory(atPath: folderUrl!.path, withIntermediateDirectories: false, attributes: [:])
            } catch {
                return .fileManager(.directoryCreationFailed(error))
            }
        }
        let fileUrl = folderUrl?.appendingPathComponent("OrganizationSearchHistory.json")
        var data: Data
        do {
            data = try JSONEncoder().encode(searchHistory)
        } catch {
            return .fileManager(.encodingJSONFailed(error))
        }
        if fileManager.fileExists(atPath: fileUrl!.path) {
            do {
                try data.write(to: fileUrl!)
            } catch {
                return .fileManager(.fileWritingFailed(error))
            }
        } else {
            fileManager.createFile(atPath: fileUrl!.path, contents: data, attributes: [:])
        }
        return nil
    }
    
    func loadUserSearchHistory() -> Result<SearchHistory<UserModel>,LibraryError> {
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        let fileUrl = folderUrl?.appendingPathComponent("UserSearchHistory.json")
        if manager.fileExists(atPath: fileUrl!.path) {
            let contents = manager.contents(atPath: fileUrl!.path)
            do {
                let data = try JSONDecoder().decode(SearchHistory<UserModel>.self, from: contents!)
                return .success(data)
            } catch {
                return .failure(.fileManager(.decodingJSONFailed(error)))
            }
        }
        return .failure(.fileManager(.fileDoesNotExist))
    }
    
    func loadRepositorySearchHistory() -> Result<SearchHistory<RepositoryModel>,LibraryError> {
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        let fileUrl = folderUrl?.appendingPathComponent("RepositorySearchHistory.json")
        if manager.fileExists(atPath: fileUrl!.path) {
            let contents = manager.contents(atPath: fileUrl!.path)
            do {
                let data = try JSONDecoder().decode(SearchHistory<RepositoryModel>.self, from: contents!)
                return .success(data)
            } catch {
                return .failure(.fileManager(.decodingJSONFailed(error)))
            }
        }
        return .failure(.fileManager(.fileDoesNotExist))
    }
    
    func loadOrganizationSearchHistory() -> Result<SearchHistory<OrganizationModel>,LibraryError> {
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        let fileUrl = folderUrl?.appendingPathComponent("OrganizationSearchHistory.json")
        if manager.fileExists(atPath: fileUrl!.path) {
            let contents = manager.contents(atPath: fileUrl!.path)
            do {
                let data = try JSONDecoder().decode(SearchHistory<OrganizationModel>.self, from: contents!)
                return .success(data)
            } catch {
                return .failure(.fileManager(.decodingJSONFailed(error)))
            }
        }
        return .failure(.fileManager(.fileDoesNotExist))
    }
    
}