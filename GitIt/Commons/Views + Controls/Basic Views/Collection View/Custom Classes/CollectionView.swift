//
//  CollectionView.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class CollectionView: UICollectionView {
    
    // MARK: - Properties
    
    var registeredCells = [CollectionViewCell.Type]()
    
    // MARK: - Data Source and Delegate Methods
    
    func setDataSource<T: CollectionCellViewModel>(_ dataSource: CollectionViewDataSource<T>) {
        self.dataSource = dataSource
        dataSource.collectionView = self
    }
    
    func setDelegate(_ delegate: CollectionViewDelegate) {
        self.delegate = delegate
        delegate.collectionView = self
    }
    
    // MARK: - Cell Methods
    
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
