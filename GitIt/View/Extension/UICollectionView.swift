//
//  UICollectionView.swift
//  GitIt
//
//  Created by Loay Ashraf on 30/12/2021.
//

import Foundation
import UIKit

extension UICollectionView {

    var registeredNibs: [String: UINib] {
        let dict = value(forKey: "_nibMap") as? [String: UINib]
        return dict ?? [:]
    }

    var registeredCells: [String: Any] {
        let dict = value(forKey: "_cellClassDict") as? [String: Any]
        return dict ?? [:]
    }
    
}

extension UICollectionViewFlowLayout {

    open override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return true
    }
    
}
