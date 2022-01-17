//
//  CollectionViewCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class UserCollectionViewCellConfigurator: CollectionViewCellConfigurator {
    
    func configure<Type>(_ cell: UICollectionViewCell, forDisplaying item: Type) {
        if let cell = cell as? RoundedImageCollectionViewCell, let item = item as? UserModel {
            cell.nameLabel.text = item.login
            cell.iconImageView.load(at: item.avatarURL)
            cell.setNeedsLayout()
        }
    }
    
}

class RepositoryCollectionViewCellConfigurator: CollectionViewCellConfigurator {
    
    func configure<Type>(_ cell: UICollectionViewCell, forDisplaying item: Type) {
        if let cell = cell as? RoundedImageCollectionViewCell, let item = item as? RepositoryModel {
            cell.nameLabel.text = item.name
            cell.iconImageView.load(at: item.owner.avatarURL)
            cell.setNeedsLayout()
        }
    }
    
}

class OrganizationCollectionViewCellConfigurator: CollectionViewCellConfigurator {
    
    func configure<Type>(_ cell: UICollectionViewCell, forDisplaying item: Type) {
        if let cell = cell as? RoundedImageCollectionViewCell, let item = item as? OrganizationModel {
            cell.nameLabel.text = item.login
            cell.iconImageView.load(at: item.avatarURL)
            cell.setNeedsLayout()
        }
    }
    
}

protocol CollectionViewCellConfigurator {
    func configure<Type>(_ cell: UICollectionViewCell, forDisplaying item: Type)
}
