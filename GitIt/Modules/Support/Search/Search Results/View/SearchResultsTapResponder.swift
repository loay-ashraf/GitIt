//
//  SearchResultsTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsTapResponder<T: SearchResultsViewModel>: TableViewTapResponder {
    
    override func respondToTap(atRow row: Int) {
        if let viewController = viewController as? SearchResultsViewController<T> {
            viewController.showDetail(atRow: row)
        }
    }
    
}
