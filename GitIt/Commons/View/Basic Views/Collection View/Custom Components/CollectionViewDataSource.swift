//
//  CollectionViewDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CollectionViewDataSource<T: CollectionCellViewModel>: NSObject, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    var cellViewModels = Array<T>()
    weak var collectionView: CollectionView? { didSet { registerCell() } }
    var cellClass: CollectionViewCell.Type?
    var cellConfigurator: CollectionViewCellConfigurator?
    
    // MARK: - Cell Registeration Methods
    
    func registerCell() {
        if let collectionView = collectionView, let cellClass = cellClass {
            collectionView.registerNib(cellClass: cellClass)
        }
    }
    
    // MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let refreshControl = collectionView.refreshControl, refreshControl.isRefreshing { return UICollectionViewCell() }
        if let collectionView = self.collectionView, let cellClass = cellClass, let cellConfigurator = cellConfigurator {
            let cell = collectionView.dequeue(cellClass: cellClass, for: indexPath)
            let item = cellViewModels[indexPath.row]
                    
            // Configure the cell...
            cellConfigurator.configure(cell, forDisplaying: item)

            return cell
        }
        return CollectionViewCell()
    }

}
