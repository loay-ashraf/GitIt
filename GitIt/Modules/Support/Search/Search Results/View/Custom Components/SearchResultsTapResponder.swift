//
//  SearchResultsTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsTapResponder<T: TableCellViewModel>: TableViewTapResponder {
    
    var rawTapResponder: TableViewTapResponder?
    weak var resultsDelegate: SearchResultsDelegate?
    
    init(delegate: SearchResultsDelegate) {
        self.resultsDelegate = delegate
        switch T.self {
        case is UserTableCellViewModel.Type: rawTapResponder = UserTableViewTapResponder()
        case is RepositoryTableCellViewModel.Type: rawTapResponder = RepositoryTableViewTapResponder()
        case is OrganizationTableCellViewModel.Type: rawTapResponder = OrganizationTableViewTapResponder()
        default: break
        }
    }
    
    override func respondToTap<T: TableCellViewModel>(with item: T) {
        resultsDelegate?.dismissResultsKeyboard()
        resultsDelegate?.addObject(with: item)
        rawTapResponder?.respondToTap(with: item)
    }
    
}
