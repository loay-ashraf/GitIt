//
//  SearchResultsDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsTableViewDataSource<T: SearchResultsViewModel>: SKTableViewDataSource<T.TableCellViewModelType> {
    
    override init() {
        super.init()
        switch T.self {
        case is UserSearchResultsViewModel.Type: cellClass = BasicTableViewCell.self
                                                 cellConfigurator = UserTableViewCellConfigurator()
        case is RepositorySearchResultsViewModel.Type: cellClass = RepositoryTableViewCell.self
                                                       cellConfigurator = RepositoryTableViewCellConfigurator()
        case is OrganizationSearchResultsViewModel.Type: cellClass = BasicTableViewCell.self
                                                         cellConfigurator = OrganizationTableViewCellConfigurator()
        default: break
        }
    }
    
}
