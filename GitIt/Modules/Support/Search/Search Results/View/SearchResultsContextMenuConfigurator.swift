//
//  SearchResultsContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class SearchResultsContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure(atRow row: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? SearchResultsViewController<UserSearchResultsViewModel> {
            let actionProvider = BasicCellActionProvider(isBookmarked: viewController.viewModel.items[row].isBookmarked,
                                                         toggleBookmark: { viewController.toggleBookmark(atRow: row) },
                                                         saveImage: { viewController.saveImage(atRow: row) },
                                                         openInSafari: { viewController.openInSafari(atRow: row) },
                                                         share: { viewController.share(atRow: row) })
            return ContextMenuConfigurationConstants.BasicCellConfiguration(with: actionProvider)
        } else if let viewController = viewController as? SearchResultsViewController<RepositorySearchResultsViewModel> {
            let actionProvider = RepositoryCellActionProvider(isBookmarked: viewController.viewModel.items[row].isBookmarked,
                                                              toggleBookmark: { viewController.toggleBookmark(atRow: row) },
                                                              openInSafari: { viewController.openInSafari(atRow: row) },
                                                              share: { viewController.share(atRow: row) })
            return ContextMenuConfigurationConstants.RepositoryCellConfiguration(with: actionProvider)
        } else if let viewController = viewController as? SearchResultsViewController<OrganizationSearchResultsViewModel> {
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
