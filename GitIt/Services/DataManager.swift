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
    
    private init() {
    }
    
    func setSessionType(sessionType: SessionType) {
        UserDefaults.standard.set(sessionType.stringValue, forKey: "Session Type")
    }
    
    func getSessionType() -> SessionType? {
        let sessionType = UserDefaults.standard.string(forKey: "Session Type")
        switch sessionType {
            case "authenticated": return .authenticated
            case "guest": return .guest
            default: return .signedOut
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
    
}

extension UIColor {

    convenience init(rgb: UInt) {
        self.init(rgb: rgb, alpha: 1.0)
    }

    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255.0
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255.0
                    b = CGFloat((hexNumber & 0x0000ff)) / 255.0
                    a = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
    
}
