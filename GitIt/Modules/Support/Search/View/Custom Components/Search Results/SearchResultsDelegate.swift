//
//  SearchResultsDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsTableViewDelegate<T: TableCellViewModel>: TableViewDelegate<T> {
    
    init(delegate: SearchResultsDelegate) {
        let tapResponder = SearchResultsTapResponder<T>(delegate: delegate)
        let contextMenuConfigurator = SearchResultsContextMenuConfigurator<T>()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
