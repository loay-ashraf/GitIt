//
//  IBTableViewCell.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import Foundation
import UIKit

protocol IBTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
    func prepareForReuse()
    
}
