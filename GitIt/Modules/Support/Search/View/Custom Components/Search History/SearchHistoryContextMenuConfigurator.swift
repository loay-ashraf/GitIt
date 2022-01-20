//
//  SearchHistoryContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 19/01/2022.
//

import UIKit

class SearchHistoryCollectionViewContextMenuConfigurator: CollectionViewContextMenuConfigurator {
    
    weak var historyCollectionDelegate: HistoryCollectionDelegate?
    
    init(delegate: HistoryCollectionDelegate) {
        self.historyCollectionDelegate = delegate
    }
    
    override func configure<Type>(collectionView: UICollectionView, indexPath: IndexPath, with item: Type) -> UIContextMenuConfiguration {
        return ContextMenuConfigurationConstants.deleteConfiguration { [weak self] in
            self?.historyCollectionDelegate?.delete(model: item)
            collectionView.deleteItems(at: [indexPath])
            self?.historyCollectionDelegate?.didUpdateCollection()
        }
    }
    
}
