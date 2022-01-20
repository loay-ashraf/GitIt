//
//  SearchHistoryTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewTapResponder: TableViewTapResponder {
    
    weak var historyTableDelegate: HistoryTableDelegate?
    
    init(delegate: HistoryTableDelegate) {
        self.historyTableDelegate = delegate
    }
    
    override func respondToTap<Type>(with item: Type) {
        historyTableDelegate?.add(keyWord: item as! String)
        historyTableDelegate?.updateTable()
        historyTableDelegate?.didUpdateTable()
    }
    
}

class SearchHistoryCollectionViewTapResponder<Type>: CollectionViewTapResponder {
    
    var rawTapResponder: CollectionViewTapResponder?
    weak var historyCollectionDelegate: HistoryCollectionDelegate?
    
    init(delegate: HistoryCollectionDelegate) {
        self.historyCollectionDelegate = delegate
        switch Type.self {
        case is UserModel.Type: rawTapResponder = UserCollectionViewTapResponder()
        case is RepositoryModel.Type: rawTapResponder = RepositoryCollectionViewTapResponder()
        case is OrganizationModel.Type: rawTapResponder = OrganizationCollectionViewTapResponder()
        default: break
        }
    }
    
    override func respondToTap<Type>(with item: Type) {
        historyCollectionDelegate?.add(model: item)
        historyCollectionDelegate?.updateCollection()
        historyCollectionDelegate?.didUpdateCollection()
        rawTapResponder?.respondToTap(with: item)
    }
    
}
