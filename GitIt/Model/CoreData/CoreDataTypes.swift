//
//  CoreDataTypes.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/12/2021.
//

import Foundation

// MARK: - Error Types

enum CoreDataError: Error {
    case saving(Error)
    case loading(Error)
    case fetching(Error)
    case deleting(Error)
    case noData
}
