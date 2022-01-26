//
//  HistoryDelegates.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import Foundation

protocol HistoryDelegate: AnyObject {
    
    func historySearch(with keyword: String)
    func dismissHistoryKeyboard()
    
}

protocol HistoryCollectionDelegate: AnyObject {
    
    var models: List<Any> { get }
    
    func add(model: Any)
    func delete(model: Any)
    func updateCollection()
    func didUpdateCollection()
    func dismissHistoryKeyboard()
    
}

protocol HistoryTableDelegate: AnyObject {
    
    var keywords: List<String> { get }
    
    func add(keyWord: String)
    func delete(keyWord: String)
    func updateTable()
    func didUpdateTable()
    
}
