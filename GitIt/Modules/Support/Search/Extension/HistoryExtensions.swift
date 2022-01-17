//
//  HistoryExtensions.swift
//  GitIt
//
//  Created by Loay Ashraf on 01/01/2022.
//

import UIKit

extension HistoryViewController {
    
    // MARK: - Search Coordinator Outlet Methods
    
    func addModel(with model: Any) {
        logicController.add(model: model as! Type)
        collectionViewController.updateView()
        layoutView()
    }
    
    func addKeyword(with keyword: String) {
        logicController.add(keyword: keyword)
        tableViewController.updateView()
        layoutView()
    }
    
}

extension HistoryViewController: HistoryCollectionDelegate {
    
    // MARK: - Collection View Controller Delegate Methods
    
    var models: List<Any> { return List<Any>(with: logicController.history.models) }
    
    func add(model: Any) {
        logicController.add(model: model as! Type)
    }
    
    func delete(model: Any) {
        logicController.delete(model: model as! Type)
    }
    
    func didUpdateCollection() {
        layoutView()
    }
    
}

extension HistoryViewController: HistoryTableDelegate {
    
    // MARK: - Table View Controller Delegate Methods
    
    var keywords: List<String> { return List<String>(with: logicController.history.keywords) }
    
    func add(keyWord: String) {
        logicController.add(keyword: keyWord)
        delegate.historySearch(with: keyWord)
    }
    
    func delete(keyWord: String) {
        logicController.delete(keyword: keyWord)
    }
    
    func didUpdateTable() {
        layoutView()
    }
    
}
