//
//  UserDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewDataSource: SKTableViewDataSource<UserTableCellViewModel> {
    
    override init() {
        super.init()
        cellClass = BasicTableViewCell.self
        cellConfigurator = UserTableViewCellConfigurator()
    }
    
}

class UserCollectionViewDataSource: CollectionViewDataSource<UserCollectionCellViewModel> {
    
    override init() {
        super.init()
        cellClass = BasicCollectionViewCell.self
        cellConfigurator = UserCollectionViewCellConfigurator()
    }
    
}
