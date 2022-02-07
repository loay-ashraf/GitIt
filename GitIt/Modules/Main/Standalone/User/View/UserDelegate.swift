//
//  UserDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewDelegate: TableViewDelegate {
    
    init(_ viewController: UserViewController) {
        super.init()
        tapResponder = UserTableViewTapResponder(viewController)
        contextMenuConfigurator = UserTableViewContextMenuConfigurator(viewController)
    }
    
}

class UserCollectionViewDelegate: CollectionViewDelegate {
    
    init(_ viewController: UserViewController) {
        super.init()
        tapResponder = UserCollectionViewTapResponder(viewController)
        contextMenuConfigurator = UserCollectionViewContextMenuConfigurator(viewController)
    }
    
}
