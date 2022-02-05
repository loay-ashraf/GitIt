//
//  SearchHistoryContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 19/01/2022.
//

import UIKit

class SearchHistoryCollectionViewContextMenuConfigurator: CollectionViewContextMenuConfigurator {
    
    weak var historyCollectionDelegate: SearchHistoryCollectionDelegate?
    
    init(delegate: SearchHistoryCollectionDelegate) {
        self.historyCollectionDelegate = delegate
    }
    
    override func configure<T: CollectionCellViewModel>(collectionView: UICollectionView, indexPath: IndexPath, with item: T) -> UIContextMenuConfiguration {
        return ContextMenuConfigurationConstants.DeleteConfiguration { [weak self] in
            self?.historyCollectionDelegate?.delete(objectCellViewModel: item)
            collectionView.deleteItems(at: [indexPath])
            self?.historyCollectionDelegate?.didUpdateCollection()
        }
    }
    
}
