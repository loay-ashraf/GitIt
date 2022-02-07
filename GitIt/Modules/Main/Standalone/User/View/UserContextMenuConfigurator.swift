//
//  UserContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure(atRow row: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? UserViewController {
            let actionProvider = BasicCellActionProvider(isBookmarked: viewController.viewModel.items[row].isBookmarked,
                                                         toggleBookmark: { viewController.toggleBookmark(atRow: row) },
                                                         saveImage: { viewController.saveImage(atRow: row) },
                                                         openInSafari: { viewController.openInSafari(atRow: row) },
                                                         share: { viewController.share(atRow: row) })
            return ContextMenuConfigurationConstants.BasicCellConfiguration(with: actionProvider)
        }
        return nil
    }
    
}

class UserCollectionViewContextMenuConfigurator: CollectionViewContextMenuConfigurator {
    
    override func configure(atItem item: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? UserViewController {
            let actionProvider = BasicCellActionProvider(isBookmarked: viewController.viewModel.items[item].isBookmarked,
                                                         toggleBookmark: { viewController.toggleBookmark(atRow: item) },
                                                         saveImage: { viewController.saveImage(atRow: item) },
                                                         openInSafari: { viewController.openInSafari(atRow: item) },
                                                         share: { viewController.share(atRow: item) })
            return ContextMenuConfigurationConstants.BasicCellConfiguration(with: actionProvider)
        }
        return nil
    }
    
}
