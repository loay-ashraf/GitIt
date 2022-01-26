//
//  DataTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/12/2021.
//

import Foundation

// MARK: - Error Types

enum DataError: Error {
    case userDefaults(UserDefaultsError)
    case fileManager(FileManagerError)
    case coreData(CoreDataError)
}

enum BundleError: Error {
    case invalidResourceURL
    case resourceReadingFailed(Error)
}

enum CoreDataError: Error {
    case saving(Error)
    case loading(Error)
    case fetching(Error)
    case deleting(Error)
    case noData
}

enum FileManagerError: Error {
    case fileDoesNotExist
    case directoryDoesNotExist(Error)
    case directoryCreationFailed(Error)
    case fileWritingFailed(Error)
    case fileReadingFailed
    case encodingJSONFailed(Error)
    case decodingJSONFailed(Error)
}

enum UserDefaultsError: Error {
    case propertyNotFound
    case unknownPropertyValue
}
