//
//  BookamrksContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import UIKit

class UserBookmarksContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure(atRow row: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? UserBookmarksViewController {
            let actionProvider = BasicCellActionProvider(isBookmarked: viewController.viewModel.cellViewModels[row].isBookmarked,
                                                         toggleBookmark: { viewController.toggleBookmark(atRow: row) },
                                                         saveImage: { viewController.saveImage(atRow: row) },
                                                         openInSafari: { viewController.openInSafari(atRow: row) },
                                                         share: { viewController.share(atRow: row) })
            return ContextMenuConfigurationConstants.BasicCellConfiguration(with: actionProvider)
        }
        return nil
    }
    
}

class RepositoryBookmarksContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure(atRow row: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? RepositoryBookmarksViewController {
            let actionProvider = RepositoryCellActionProvider(isBookmarked: viewController.viewModel.cellViewModels[row].isBookmarked,
                                                              toggleBookmark: { viewController.toggleBookmark(atRow: row) },
                                                              openInSafari: { viewController.openInSafari(atRow: row) },
                                                              share: { viewController.share(atRow: row) })
            return ContextMenuConfigurationConstants.RepositoryCellConfiguration(with: actionProvider)
        }
        return nil
    }
    
}

class OrganizationBookmarksContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure(atRow row: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? OrganizationBookmarksViewController {
            let actionProvider = BasicCellActionProvider(isBookmarked: viewController.viewModel.cellViewModels[row].isBookmarked,
                                                         toggleBookmark: { viewController.toggleBookmark(atRow: row) },
                                                         saveImage: { viewController.saveImage(atRow: row) },
                                                         openInSafari: { viewController.openInSafari(atRow: row) },
                                                         share: { viewController.share(atRow: row) })
            return ContextMenuConfigurationConstants.BasicCellConfiguration(with: actionProvider)
        }
        return nil
    }
    
}
