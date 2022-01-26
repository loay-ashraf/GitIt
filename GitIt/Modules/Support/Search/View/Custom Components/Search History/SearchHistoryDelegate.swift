//
//  SearchHistoryDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDelegate: TableViewDelegate<String> {
    
    init(tableDelegate: HistoryTableDelegate) {
        let tapResponder = SearchHistoryTableViewTapResponder(delegate: tableDelegate)
        super.init(tapResponder: tapResponder, contextMenuConfigurator: nil, scrollViewAction: nil)
    }
    
}

class SearchHistoryCollectionViewDelegate<Type>: CollectionViewDelegate<Type> {
    
    init(collectionDelegate: HistoryCollectionDelegate) {
        let tapResponder = SearchHistoryCollectionViewTapResponder<Type>(delegate: collectionDelegate)
        let contextMenuConfigurator = SearchHistoryCollectionViewContextMenuConfigurator(delegate: collectionDelegate)
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
