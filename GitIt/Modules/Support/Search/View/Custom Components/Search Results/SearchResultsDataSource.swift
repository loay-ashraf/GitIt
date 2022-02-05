//
//  SearchResultsDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsTableViewDataSource<T: TableCellViewModel>: TableViewDataSource<T> {
    
    class func raw() -> TableViewDataSource<T> {
        switch T.self {
        case is UserTableCellViewModel.Type: return TableViewDataSourceConstants.userDataSource as! TableViewDataSource<T>
        case is RepositoryTableCellViewModel.Type: return TableViewDataSourceConstants.repositoryDataSource as! TableViewDataSource<T>
        case is OrganizationTableCellViewModel.Type: return TableViewDataSourceConstants.organizationDataSource as! TableViewDataSource<T>
        default: return TableViewDataSource<T>()
        }
    }
    
}
