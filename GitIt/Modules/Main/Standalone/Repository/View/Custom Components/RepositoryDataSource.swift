//
//  RepositoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDataSource: SKTableViewDataSource<RepositoryTableCellViewModel> {
    
    override init() {
        super.init()
        cellClass = RepositoryTableViewCell.self
        cellConfigurator = RepositoryTableViewCellConfigurator()
    }
    
}

class RepositoryCollectionViewDataSource: SKCollectionViewDataSource<RepositoryCollectionCellViewModel> {
    
    override init() {
        super.init()
        cellClass = BasicCollectionViewCell.self
        cellConfigurator = RepositoryCollectionViewCellConfigurator()
    }
    
}
