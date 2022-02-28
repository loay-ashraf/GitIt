//
//  RepositoryContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure(atRow row: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? RepositoryViewController {
            let actionProvider = RepositoryCellActionProvider(isBookmarked: viewController.viewModel.items[row].isBookmarked,
                                                              toggleBookmark: { viewController.toggleBookmark(atRow: row) },
                                                              openInSafari: { viewController.openInSafari(atRow: row) },
                                                              share: { viewController.share(atRow: row) })
            return ContextMenuConfigurationConstants.RepositoryCellConfiguration(with: actionProvider)
        }
        return nil
    }
    
}

class RepositoryCollectionViewContextMenuConfigurator: CollectionViewContextMenuConfigurator {
    
    override func configure(atItem item: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? RepositoryViewController {
            let actionProvider = RepositoryCellActionProvider(isBookmarked: viewController.viewModel.items[item].isBookmarked,
                                                              toggleBookmark: { viewController.toggleBookmark(atRow: item) },
                                                              openInSafari: { viewController.openInSafari(atRow: item) },
                                                              share: { viewController.share(atRow: item) })
            return ContextMenuConfigurationConstants.RepositoryCellConfiguration(with: actionProvider)
        }
        return nil
    }
    
}
