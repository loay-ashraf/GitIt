//
//  SearchHistoryViewControllerProtocol.swift
//  GitIt
//
//  Created by Loay Ashraf on 06/02/2022.
//

import Foundation

protocol SearchHistoryDelegate: AnyObject {
    
    func historySearch(with query: String)
    func dismissHistoryKeyboard()
    
}

protocol SearchHistoryCollectionDelegate: AnyObject {
    
    var objectCellViewModels: Array<AnyObject> { get }
    
    func add(objectCellViewModel: AnyObject)
    func delete(objectCellViewModel: AnyObject)
    func updateCollection()
    func didUpdateCollection()
    func dismissHistoryKeyboard()
    
}

protocol SearchHistoryTableDelegate: AnyObject {
    
    var queryCellViewModels: Array<QueryCellViewModel> { get }
    
    func add(queryCellViewModel: QueryCellViewModel)
    func delete(queryCellViewModel: QueryCellViewModel)
    func updateTable()
    func didUpdateTable()
    
}
