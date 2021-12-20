//
//  LibraryTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/12/2021.
//

import Foundation

// MARK: - Error Types

enum LibraryError: Error {
    case userDefaults(UserDefaultsError)
    case fileManager(FileManagerError)
}

enum UserDefaultsError: Error {
    case propertyNotFound
    case unknownPropertyValue
}

enum FileManagerError: Error {
    case fileDoesNotExist
    case directoryDoesNotExist
    case directoryCreationFailed
    case fileWritingFailed
    case fileReadingFailed
    case encodingJSONFailed
    case decodingJSONFailed
}
