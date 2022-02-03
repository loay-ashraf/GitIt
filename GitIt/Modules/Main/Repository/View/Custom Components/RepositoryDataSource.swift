//
//  RepositoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDataSource: TableViewDataSource<RepositoryModel> {
    
    override init() {
        let cellClass = RepositoryTableViewCell.self
        let cellConfigurator = RepositoryTableViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: nil)
    }
    
}

class yz: TableViewDataSource<RepositoryCellViewModel> {
    
    override init() {
        let cellClass = RepositoryTableViewCell.self
        let cellConfigurator = RepositoryTableViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: nil)
    }
    
}

class RepositoryCollectionViewDataSource: CollectionViewDataSource<RepositoryModel> {
    
    override init() {
        let cellClass = RoundedImageCollectionViewCell.self
        let cellConfigurator = RepositoryCollectionViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator)
    }
    
}
