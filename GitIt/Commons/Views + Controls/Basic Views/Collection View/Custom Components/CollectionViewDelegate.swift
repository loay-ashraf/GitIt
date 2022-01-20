//
//  CollectionViewDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CollectionViewDelegate<Type>: NSObject, UICollectionViewDelegate {
    
    var model = List<Type>()
    weak var collectionView: CollectionView!
    var tapResponder: CollectionViewTapResponder!
    var contextMenuConfigurator: CollectionViewContextMenuConfigurator!
    var scrollViewAction: (() -> Void)!
    
    override init() {
        super.init()
        self.tapResponder = CollectionViewTapResponder()
        self.contextMenuConfigurator = CollectionViewContextMenuConfigurator()
    }
    
    init(tapResponder: CollectionViewTapResponder, contextMenuConfigurator: CollectionViewContextMenuConfigurator?, scrollViewAction: (() -> Void)?) {
        super.init()
        self.tapResponder = tapResponder
        self.contextMenuConfigurator = contextMenuConfigurator
        self.scrollViewAction = scrollViewAction
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = model.items[indexPath.row]
        tapResponder.respondToTap(with: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = model.items[indexPath.item]
        return contextMenuConfigurator.configure(collectionView: collectionView, indexPath: indexPath, with: item)
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewAction?()
    }

}
