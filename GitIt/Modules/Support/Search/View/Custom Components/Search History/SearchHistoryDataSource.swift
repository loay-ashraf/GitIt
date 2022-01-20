//
//  SearchHistoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDataSource: TableViewDataSource<String> {
    
    init(tableDelegate: HistoryTableDelegate) {
        let cellClass = SearchHistoryTableViewCell.self
        let cellConfigurator = SearchHistoryTableViewCellConfigurator()
        let swipeResponder = SearchHistoryTableViewSwipeResponder(delegate: tableDelegate)
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: swipeResponder)
    }
    
}

class SearchHistoryCollectionViewDataSource<Type>: CollectionViewDataSource<Type> {
    
    override init() {
        let cellClass = RoundedImageCollectionViewCell.self
        let cellConfigurator = SearchHistoryCollectionViewCellConfigurator<Type>()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator)
    }
    
}
