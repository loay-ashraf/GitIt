//
//  SearchHistoryTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewTapResponder: TableViewTapResponder {
    
    weak var historyTableDelegate: SearchHistoryTableDelegate?
    
    init(delegate: SearchHistoryTableDelegate) {
        self.historyTableDelegate = delegate
    }
    
    override func respondToTap<T: TableCellViewModel>(with item: T) {
        historyTableDelegate?.add(queryCellViewModel: item as! QueryCellViewModel)
        historyTableDelegate?.updateTable()
        historyTableDelegate?.didUpdateTable()
    }
    
}

class SearchHistoryCollectionViewTapResponder<T: CollectionCellViewModel>: CollectionViewTapResponder {
    
    var rawTapResponder: CollectionViewTapResponder?
    weak var historyCollectionDelegate: SearchHistoryCollectionDelegate?
    
    init(delegate: SearchHistoryCollectionDelegate) {
        self.historyCollectionDelegate = delegate
        switch T.self {
        case is UserCollectionCellViewModel.Type: rawTapResponder = UserCollectionViewTapResponder()
        case is RepositoryCollectionCellViewModel.Type: rawTapResponder = RepositoryCollectionViewTapResponder()
        case is OrganizationCollectionCellViewModel.Type: rawTapResponder = OrganizationCollectionViewTapResponder()
        default: break
        }
    }
    
    override func respondToTap<T: CollectionCellViewModel>(with item: T) {
        historyCollectionDelegate?.dismissHistoryKeyboard()
        historyCollectionDelegate?.add(objectCellViewModel: item)
        historyCollectionDelegate?.updateCollection()
        historyCollectionDelegate?.didUpdateCollection()
        rawTapResponder?.respondToTap(with: item)
    }
    
}
