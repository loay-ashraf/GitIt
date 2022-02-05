//
//  SearchResultsContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsContextMenuConfigurator<T: TableCellViewModel>: TableViewContextMenuConfigurator {
    
    var rawConfigurator: TableViewContextMenuConfigurator!
    
    override init() {
        super.init()
        switch T.self {
        case is UserTableCellViewModel.Type: rawConfigurator = UserTableViewContextMenuConfigurator()
        case is RepositoryTableCellViewModel.Type: rawConfigurator = RepositoryTableViewContextMenuConfigurator()
        case is OrganizationTableCellViewModel.Type: rawConfigurator = OrganizationTableViewContextMenuConfigurator()
        default: break
        }
    }
    
    override func configure<T: TableCellViewModel>(with item: T) -> UIContextMenuConfiguration {
        rawConfigurator.configure(with: item)
    }
    
}
