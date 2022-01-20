//
//  UserContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit



class UserTableViewContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure<Type>(with item: Type) -> UIContextMenuConfiguration {
        return ContextMenuConfigurationConstants.bookmarkAndShareConfiguration(for: item as! UserModel)
    }
    
}

class UserCollectionViewContextMenuConfigurator: CollectionViewContextMenuConfigurator {
    
    override func configure<Type>(collectionView: UICollectionView, indexPath: IndexPath, with item: Type) -> UIContextMenuConfiguration {
        return ContextMenuConfigurationConstants.bookmarkAndShareConfiguration(for: item as! UserModel)
    }
    
}
