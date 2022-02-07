//
//  SearchResultsDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsTableViewDelegate<T: SearchResultsViewModel>: TableViewDelegate {
    
    init(_ viewController: UIViewController) {
        super.init()
        tapResponder = SearchResultsTapResponder<T>(viewController)
        contextMenuConfigurator = SearchResultsContextMenuConfigurator(viewController)
    }
    
}
