//
//  RepositoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDataSource: TableViewDataSource<RepositoryTableCellViewModel> {
    
    override init() {
        super.init()
        cellClass = RepositoryTableViewCell.self
        cellConfigurator = RepositoryTableViewCellConfigurator()
    }
    
}

class RepositoryCollectionViewDataSource: CollectionViewDataSource<RepositoryCollectionCellViewModel> {
    
    override init() {
        super.init()
        cellClass = BasicCollectionViewCell.self
        cellConfigurator = RepositoryCollectionViewCellConfigurator()
    }
    
}
