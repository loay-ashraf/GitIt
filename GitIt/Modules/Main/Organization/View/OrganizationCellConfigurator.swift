//
//  OrganizationCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewCellConfigurator: TableViewCellConfigurator {
    
    override func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? RoundedImageTableViewCell, let item = item as? OrganizationModel {
            cell.nameLabel.text = item.login
            cell.iconImageView.load(at: item.avatarURL)
            cell.setNeedsLayout()
        }
    }
    
}

class OrganizationCollectionViewCellConfigurator: CollectionViewCellConfigurator {
    
    override func configure<Type>(_ cell: UICollectionViewCell, forDisplaying item: Type) {
        if let cell = cell as? RoundedImageCollectionViewCell, let item = item as? OrganizationModel {
            cell.nameLabel.text = item.login
            cell.iconImageView.load(at: item.avatarURL)
            cell.setNeedsLayout()
        }
    }
    
}
