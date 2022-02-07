//
//  RepositoryDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDelegate: TableViewDelegate {
    
    init(_ viewController: RepositoryViewController) {
        super.init()
        tapResponder = RepositoryTableViewTapResponder(viewController)
        contextMenuConfigurator = RepositoryTableViewContextMenuConfigurator(viewController)
    }
    
}

class RepositoryCollectionViewDelegate: CollectionViewDelegate {
    
    init(_ viewController: RepositoryViewController) {
        super.init()
        tapResponder = RepositoryCollectionViewTapResponder(viewController)
        contextMenuConfigurator = RepositoryCollectionViewContextMenuConfigurator(viewController)
    }
    
}
