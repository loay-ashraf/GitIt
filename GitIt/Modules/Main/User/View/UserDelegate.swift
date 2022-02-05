//
//  UserDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewDelegate: TableViewDelegate<UserTableCellViewModel> {
    
    override init() {
        let tapResponder = UserTableViewTapResponder()
        let contextMenuConfigurator = UserTableViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}

class UserCollectionViewDelegate: CollectionViewDelegate<UserCollectionCellViewModel> {
    
    override init() {
        let tapResponder = UserCollectionViewTapResponder()
        let contextMenuConfigurator = UserCollectionViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
