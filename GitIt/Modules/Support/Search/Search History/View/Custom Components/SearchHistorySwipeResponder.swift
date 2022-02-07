//
//  SearchHistorySwipeResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 19/01/2022.
//

import UIKit

class SearchHistoryTableViewSwipeResponder<T: SearchHistoryViewModel>: TableViewSwipeResponder {
    
    override func respondToSwipe(editingStyle: UITableViewCell.EditingStyle, atRow row: Int) {
        if let viewController = viewController as? SearchHistoryViewController<T>, editingStyle == .delete {
            viewController.deleteQuery(atRow: row)
        }
    }
    
}
