//
//  UserDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewDataSource: TableViewDataSource<UserModel> {
    
    override init() {
        let cellClass = RoundedImageTableViewCell.self
        let cellConfigurator = UserTableViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: nil)
    }
    
}

class z: TableViewDataSource<UserCellViewModel> {
    
    override init() {
        let cellClass = RoundedImageTableViewCell.self
        let cellConfigurator = UserTableViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: nil)
    }
    
}

class UserCollectionViewDataSource: CollectionViewDataSource<UserModel> {
    
    override init() {
        let cellClass = RoundedImageCollectionViewCell.self
        let cellConfigurator = UserCollectionViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator)
    }
    
}
