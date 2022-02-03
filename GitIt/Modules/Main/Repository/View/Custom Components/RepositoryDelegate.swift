//
//  RepositoryDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDelegate: TableViewDelegate<RepositoryModel> {
    
    override init() {
        let tapResponder = RepositoryTableViewTapResponder()
        let contextMenuConfigurator = RepositoryTableViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}

class xz: TableViewDelegate<RepositoryCellViewModel> {
    
    override init() {
        let tapResponder = RepositoryTableViewTapResponder()
        let contextMenuConfigurator = RepositoryTableViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}

class RepositoryCollectionViewDelegate: CollectionViewDelegate<RepositoryModel> {
    
    override init() {
        let tapResponder = RepositoryCollectionViewTapResponder()
        let contextMenuConfigurator = RepositoryCollectionViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
