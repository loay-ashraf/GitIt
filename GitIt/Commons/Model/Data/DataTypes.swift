//
//  DataTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/12/2021.
//

import Foundation
import RealmSwift

// MARK: - Error Types

enum DataError: Error {
    case bundle(BundleError)
    case userDefaults(UserDefaultsError)
    case fileManager(FileManagerError)
    case realm(RealmError)
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

typealias RealmQuery<T> = (Query<T>) -> Query<Bool>

enum RealmError: Error {
    case saving(Error)
    case loading(Error)
    case writing(Error)
    case reading(Error)
    case unsupportedModelType
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
