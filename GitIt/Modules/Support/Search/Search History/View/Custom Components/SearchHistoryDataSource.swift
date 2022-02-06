//
//  SearchHistoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDataSource: TableViewDataSource<QueryCellViewModel> {
    
    init(tableDelegate: SearchHistoryTableDelegate) {
        let cellClass = SearchHistoryTableViewCell.self
        let cellConfigurator = SearchHistoryTableViewCellConfigurator()
        let swipeResponder = SearchHistoryTableViewSwipeResponder(delegate: tableDelegate)
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: swipeResponder)
    }
    
}

class SearchHistoryCollectionViewDataSource<T: CollectionCellViewModel>: CollectionViewDataSource<T> {
    
    class func raw() -> CollectionViewDataSource<T> {
        switch T.self {
        case is UserCollectionCellViewModel.Type: return CollectionViewDataSourceConstants.userDataSource as! CollectionViewDataSource<T>
        case is RepositoryCollectionCellViewModel.Type: return CollectionViewDataSourceConstants.repositoryDataSource as! CollectionViewDataSource<T>
        case is OrganizationCollectionCellViewModel.Type: return CollectionViewDataSourceConstants.organizationDataSource as! CollectionViewDataSource<T>
        default: return CollectionViewDataSource<T>()
        }
    }
    
}
