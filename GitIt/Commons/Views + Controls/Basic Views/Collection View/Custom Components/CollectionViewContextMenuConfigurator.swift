//
//  CollectionViewContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CollectionViewContextMenuConfigurator {
    
    func configure<T: CollectionCellViewModel>(collectionView: UICollectionView, indexPath: IndexPath, with item: T) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration()
    }
    
}
