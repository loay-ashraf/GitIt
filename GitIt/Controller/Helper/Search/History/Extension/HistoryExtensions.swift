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
        add(model: model)
        collectionViewController.updateView()
        layoutView()
    }
    
    func addKeyword(with keyword: String) {
        navigationController?.popToRootViewController(animated: false)
        add(keyWord: keyword)
        tableViewController.updateView()
        layoutView()
    }
    
}

extension HistoryViewController: HistoryCollectionDelegate {
    
    // MARK: - Collection View Controller Delegate Methods
    
    var models: List<Any> { return List<Any>(with: logicController.history.models) }
    
    func add(model: Any) {
        logicController.addToHistory(model: model as! Type)
    }
    
    func delete(model: Any) {
        logicController.deleteFromHistory(model: model as! Type)
    }
    
    func didUpdateCollection() {
        layoutView()
    }
    
}

extension HistoryViewController: HistoryTableDelegate {
    
    // MARK: - Table View Controller Delegate Methods
    
    var keywords: List<String> { return List<String>(with: logicController.history.keywords) }
    
    func add(keyWord: String) {
        logicController.addToHistory(keyWord: keyWord)
        delegate.historySearch(with: keyWord)
    }
    
    func delete(keyWord: String) {
        logicController.deleteFromHistory(keyWord: keyWord)
    }
    
    func didUpdateTable() {
        layoutView()
    }
    
}
