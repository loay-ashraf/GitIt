//
//  SearchHistoryDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDelegate: TableViewDelegate<QueryCellViewModel> {
    
    init(tableDelegate: SearchHistoryTableDelegate) {
        let tapResponder = SearchHistoryTableViewTapResponder(delegate: tableDelegate)
        super.init(tapResponder: tapResponder, contextMenuConfigurator: nil, scrollViewAction: nil)
    }
    
}

class SearchHistoryCollectionViewDelegate<T: CollectionCellViewModel>: CollectionViewDelegate<T> {
    
    init(collectionDelegate: SearchHistoryCollectionDelegate) {
        let tapResponder = SearchHistoryCollectionViewTapResponder<T>(delegate: collectionDelegate)
        let contextMenuConfigurator = SearchHistoryCollectionViewContextMenuConfigurator(delegate: collectionDelegate)
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
