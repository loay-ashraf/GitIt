//
//  SearchHistoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDataSource: TableViewDataSource<String> {
    
    init(tableDelegate: HistoryTableDelegate) {
        let cellClass = SearchHistoryTableViewCell.self
        let cellConfigurator = SearchHistoryTableViewCellConfigurator()
        let swipeResponder = SearchHistoryTableViewSwipeResponder(delegate: tableDelegate)
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: swipeResponder)
    }
    
}

class SearchHistoryCollectionViewDataSource<Type>: CollectionViewDataSource<Type> {
    
    class func raw() -> CollectionViewDataSource<Type> {
        switch Type.self {
        case is UserModel.Type: return CollectionViewDataSourceConstants.userDataSource as! CollectionViewDataSource<Type>
        case is RepositoryModel.Type: return CollectionViewDataSourceConstants.repositoryDataSource as! CollectionViewDataSource<Type>
        case is OrganizationModel.Type: return CollectionViewDataSourceConstants.organizationDataSource as! CollectionViewDataSource<Type>
        default: return CollectionViewDataSource<Type>()
        }
    }
    
}
