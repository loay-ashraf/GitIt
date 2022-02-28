//
//  SearchHistoryTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewTapResponder<T: SearchHistoryViewModel>: TableViewTapResponder {
    
    override func respondToTap(atRow row: Int) {
        if let viewController = viewController as? SearchHistoryViewController<T> {
            viewController.reloadQuery(atRow: row)
        }
    }
    
}

class SearchHistoryCollectionViewTapResponder<T: SearchHistoryViewModel>: CollectionViewTapResponder {
    
    override func respondToTap(atItem item: Int) {
        if let viewController = viewController as? SearchHistoryViewController<T> {
            viewController.reloadObject(atItem: item)
        }
    }
    
}
