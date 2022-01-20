//
//  SeachHistoryCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewCellConfigurator: TableViewCellConfigurator {
    
    override func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? SearchHistoryTableViewCell, let item = item as? String {
            cell.historyLabel.text = item
            cell.setNeedsLayout()
        }
    }
    
}

class SearchHistoryCollectionViewCellConfigurator<Type>: CollectionViewCellConfigurator {
    
    var rawConfigurator: CollectionViewCellConfigurator!
    
    override init() {
        super.init()
        switch Type.self {
        case is UserModel.Type: rawConfigurator = UserCollectionViewCellConfigurator()
        case is RepositoryModel.Type: rawConfigurator = RepositoryCollectionViewCellConfigurator()
        case is OrganizationModel.Type: rawConfigurator = OrganizationCollectionViewCellConfigurator()
        default: break
        }
    }
    
    override func configure<Type>(_ cell: UICollectionViewCell, forDisplaying item: Type) {
        rawConfigurator.configure(cell, forDisplaying: item)
    }
    
}
