//
//  RepositoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDataSource: TableViewDataSource<RepositoryTableCellViewModel> {
    
    override init() {
        let cellClass = RepositoryTableViewCell.self
        let cellConfigurator = RepositoryTableViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: nil)
    }
    
}

class RepositoryCollectionViewDataSource: CollectionViewDataSource<RepositoryCollectionCellViewModel> {
    
    override init() {
        let cellClass = RoundedImageCollectionViewCell.self
        let cellConfigurator = RepositoryCollectionViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator)
    }
    
}
