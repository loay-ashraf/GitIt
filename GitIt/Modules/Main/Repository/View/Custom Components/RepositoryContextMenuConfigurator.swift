//
//  RepositoryContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure<Type>(with item: Type) -> UIContextMenuConfiguration {
        return ContextMenuConfigurationConstants.RepositoryCellConfiguration(for: item as! RepositoryModel)
    }
    
}

class RepositoryCollectionViewContextMenuConfigurator: CollectionViewContextMenuConfigurator {
    
    override func configure<Type>(collectionView: UICollectionView, indexPath: IndexPath, with item: Type) -> UIContextMenuConfiguration {
        return ContextMenuConfigurationConstants.RepositoryCellConfiguration(for: item as! RepositoryModel)
    }
    
}
