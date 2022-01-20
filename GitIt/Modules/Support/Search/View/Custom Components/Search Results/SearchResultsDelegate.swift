//
//  SearchResultsDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsDelegate<Type>: TableViewDelegate<Type> {
    
    init(delegate: ResultsDelegate) {
        let tapResponder = SearchResultsTapResponder<Type>(delegate: delegate)
        let contextMenuConfigurator = SearchResultsContextMenuConfigurator<Type>()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
