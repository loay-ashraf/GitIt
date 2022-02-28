//
//  DataProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import Foundation

protocol DataPersistenceProvider { }

protocol DataPersistenceManager {
    
    associatedtype DataPersistenceProviderType: DataPersistenceProvider
    
    var dataPersistenceProvider: DataPersistenceProviderType { get }
    
}
