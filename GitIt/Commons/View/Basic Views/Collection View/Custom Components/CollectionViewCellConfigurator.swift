//
//  CollectionViewCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class CollectionViewCellConfigurator {
    
    func configure<T: CollectionCellViewModel>(_ cell: UICollectionViewCell, forDisplaying item: T) { /* override this method in sub classes */ }
    
}
