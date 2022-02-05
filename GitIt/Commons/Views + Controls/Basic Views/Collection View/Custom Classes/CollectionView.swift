//
//  CollectionView.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class CollectionView: UICollectionView {
    
    var registeredCells = [CollectionViewCell.Type]()
    
    func setDataSource<T: CollectionCellViewModel>(_ dataSource: CollectionViewDataSource<T>) {
        self.dataSource = dataSource
        dataSource.collectionView = self
    }
    
    func setDelegate<T: CollectionCellViewModel>(_ delegate: CollectionViewDelegate<T>) {
        self.delegate = delegate
        delegate.collectionView = self
    }
    
    func registerClass<T: CollectionViewCell>(cellClass: T.Type) {
        if !registeredCells.contains(where: { $0 == cellClass }) {
            register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
            registeredCells.append(cellClass)
        }
    }
    
    func registerNib<T: CollectionViewCell>(cellClass: T.Type) {
        if !registeredCells.contains(where: { $0 == cellClass }) {
            register(cellClass.nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
            registeredCells.append(cellClass)
        }
    }
    
    func dequeue<T: CollectionViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        if registeredCells.contains(where: { $0 == cellClass }) {
            return dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
        }
        return CollectionViewCell() as! T
    }
    
}
