//
//  ModelProtocols.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/02/2022.
//

import Foundation

protocol Model: Codable, Equatable {
    
    associatedtype CollectionCellViewModelType: CollectionCellViewModel
    associatedtype TableCellViewModelType: TableCellViewModel
    
    var id: Int { get }
    var htmlURL: URL { get }
    var isComplete: Bool { get set }
    
    init()
    init(from collectionCellViewModel: CollectionCellViewModelType)
    init(from tableCellViewModel: TableCellViewModelType)
    
}
