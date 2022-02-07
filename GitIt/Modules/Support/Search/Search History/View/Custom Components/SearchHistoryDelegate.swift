//
//  SearchHistoryDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDelegate<T: SearchHistoryViewModel>: TableViewDelegate {
    
    init(_ viewController: UIViewController) {
        super.init()
        tapResponder = SearchHistoryTableViewTapResponder<T>(viewController)
    }
    
}

class SearchHistoryCollectionViewDelegate<T: SearchHistoryViewModel>: CollectionViewDelegate {
    
    init(_ viewController: UIViewController) {
        super.init()
        tapResponder = SearchHistoryCollectionViewTapResponder<T>(viewController)
        contextMenuConfigurator = SearchHistoryContextMenuConfigurator(viewController)
    }
    
}
