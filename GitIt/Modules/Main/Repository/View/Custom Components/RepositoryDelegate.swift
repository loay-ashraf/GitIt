//
//  RepositoryDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDelegate: TableViewDelegate<RepositoryTableCellViewModel> {
    
    override init() {
        let tapResponder = RepositoryTableViewTapResponder()
        let contextMenuConfigurator = RepositoryTableViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}

class RepositoryCollectionViewDelegate: CollectionViewDelegate<RepositoryCollectionCellViewModel> {
    
    override init() {
        let tapResponder = RepositoryCollectionViewTapResponder()
        let contextMenuConfigurator = RepositoryCollectionViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
