//
//  CollectionViewDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CollectionViewDataSource<Type>: NSObject, UICollectionViewDataSource {
    
    var model = List<Type>()
    weak var collectionView: CollectionView! { didSet { registerCell() } }
    var cellClass: CollectionViewCell.Type!
    var cellConfigurator: CollectionViewCellConfigurator!
    
    // MARK: - Initialisation
    
    override init() {
        super.init()
        self.cellClass = CollectionViewCell.self
        self.cellConfigurator = CollectionViewCellConfigurator()
    }
    
    init(cellClass: CollectionViewCell.Type, cellConfigurator: CollectionViewCellConfigurator) {
        super.init()
        self.cellClass = cellClass
        self.cellConfigurator = cellConfigurator
    }
    
    func registerCell() {
        collectionView.registerNib(cellClass: cellClass)
    }
    
    // MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let refreshControl = collectionView.refreshControl, refreshControl.isRefreshing { return UICollectionViewCell() }
        let cell = self.collectionView.dequeue(cellClass: cellClass, for: indexPath)
        let item = model.items[indexPath.row]
                
        // Configure the cell...
        cellConfigurator.configure(cell, forDisplaying: item)

        return cell
    }

}
