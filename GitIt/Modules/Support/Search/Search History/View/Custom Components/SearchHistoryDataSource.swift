//
//  SearchHistoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDataSource<T: SearchHistoryViewModel>: TableViewDataSource<QueryCellViewModel> {
    
    init(_ viewController: UIViewController) {
        super.init()
        cellClass = SearchHistoryTableViewCell.self
        cellConfigurator = SearchHistoryTableViewCellConfigurator()
        swipeResponder = SearchHistoryTableViewSwipeResponder<T>(viewController)
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
