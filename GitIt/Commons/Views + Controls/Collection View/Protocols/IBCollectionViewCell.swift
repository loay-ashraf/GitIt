//
//  IBCollectionViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/12/2021.
//

import Foundation
import UIKit

protocol IBCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
    func prepareForReuse()
    
}
