//
//  DataManager.swift
//  GitIt
//
//  Created by Loay Ashraf on 03/11/2021.
//

import Foundation
import UIKit

class DataManager {
    
    static let shared = DataManager()
    
    var colors: [String:String]
    
    private init() {
        let url = Bundle.main.url(forResource: "LanguageColors", withExtension: "json")
        let data = try? Data(contentsOf: url!, options: .mappedIfSafe)
        colors = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:String]
    }
    
    func setSessionType(sessionType: SessionType) {
        UserDefaults.standard.set(sessionType.stringValue, forKey: "Session Type")
    }
    
    func getSessionType() -> SessionType {
        let sessionType = UserDefaults.standard.string(forKey: "Session Type")
        switch sessionType {
            case "authenticated": return .authenticated
            case "guest": return .guest
            default: return .signedOut
        }
    }
    
    func setThemeType(themeType: ThemeType) {
        UserDefaults.standard.set(themeType.stringValue, forKey: "Theme Type")
    }
    
    func getThemeType() -> ThemeType? {
        let themeType = UserDefaults.standard.string(forKey: "Theme Type")
        switch themeType {
            case "Follow System": return .followSystem
            case "Light": return .light
            case "Dark": return .dark
            default: return .followSystem
        }
    }
    
    func saveUserSearchHistory(searchHistory: SearchHistory<UserModel>) {
        let encoder = JSONEncoder()
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        if !manager.fileExists(atPath: folderUrl!.path) {
            try? manager.createDirectory(atPath: folderUrl!.path, withIntermediateDirectories: false, attributes: [:])
        }
        let fileUrl = folderUrl?.appendingPathComponent("UserSearchHistory.json")
        let data = try? encoder.encode(searchHistory)
        if manager.fileExists(atPath: fileUrl!.path) {
            do {
                try data!.write(to: fileUrl!)
            } catch {
               fatalError("Error saving search history")
            }
        } else {
            manager.createFile(atPath: fileUrl!.path, contents: data, attributes: [:])
        }
    }
    
    func saveRepositorySearchHistory(searchHistory: SearchHistory<RepositoryModel>) {
        let encoder = JSONEncoder()
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        if !manager.fileExists(atPath: folderUrl!.path) {
            try? manager.createDirectory(atPath: folderUrl!.path, withIntermediateDirectories: false, attributes: [:])
        }
        let fileUrl = folderUrl?.appendingPathComponent("RepositorySearchHistory.json")
        let data = try? encoder.encode(searchHistory)
        if manager.fileExists(atPath: fileUrl!.path) {
            do {
                try data!.write(to: fileUrl!)
            } catch {
               fatalError("Error saving search history")
            }
        } else {
            manager.createFile(atPath: fileUrl!.path, contents: data, attributes: [:])
        }
    }
    
    func saveOrganizationSearchHistory(searchHistory: SearchHistory<OrganizationModel>) {
        let encoder = JSONEncoder()
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        if !manager.fileExists(atPath: folderUrl!.path) {
            try? manager.createDirectory(atPath: folderUrl!.path, withIntermediateDirectories: false, attributes: [:])
        }
        let fileUrl = folderUrl?.appendingPathComponent("OrganizationSearchHistory.json")
        let data = try? encoder.encode(searchHistory)
        if manager.fileExists(atPath: fileUrl!.path) {
            do {
                try data!.write(to: fileUrl!)
            } catch {
               fatalError("Error saving search history")
            }
        } else {
            manager.createFile(atPath: fileUrl!.path, contents: data, attributes: [:])
        }
    }
    
    func loadUserSearchHistory() -> SearchHistory<UserModel>? {
        let decoder = JSONDecoder()
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        let fileUrl = folderUrl?.appendingPathComponent("UserSearchHistory.json")
        if manager.fileExists(atPath: fileUrl!.path) {
            let contents = manager.contents(atPath: fileUrl!.path)
            do {
                let data = try decoder.decode(SearchHistory<UserModel>.self, from: contents!)
                return data
            } catch {
               fatalError("Error loading search history")
            }
        }
        return nil
    }
    
    func loadRepositorySearchHistory() -> SearchHistory<RepositoryModel>? {
        let decoder = JSONDecoder()
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        let fileUrl = folderUrl?.appendingPathComponent("RepositorySearchHistory.json")
        if manager.fileExists(atPath: fileUrl!.path) {
            let contents = manager.contents(atPath: fileUrl!.path)
            do {
                let data = try decoder.decode(SearchHistory<RepositoryModel>.self, from: contents!)
                return data
            } catch {
               fatalError("Error loading search history")
            }
        }
        return nil
    }
    
    func loadOrganizationSearchHistory() -> SearchHistory<OrganizationModel>? {
        let decoder = JSONDecoder()
        let manager = FileManager.default
        let url = manager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        let folderUrl = url?.appendingPathComponent("Search History")
        let fileUrl = folderUrl?.appendingPathComponent("OrganizationSearchHistory.json")
        if manager.fileExists(atPath: fileUrl!.path) {
            let contents = manager.contents(atPath: fileUrl!.path)
            do {
                let data = try decoder.decode(SearchHistory<OrganizationModel>.self, from: contents!)
                return data
            } catch {
               fatalError("Error loading search history")
            }
        }
        return nil
    }
    
}
