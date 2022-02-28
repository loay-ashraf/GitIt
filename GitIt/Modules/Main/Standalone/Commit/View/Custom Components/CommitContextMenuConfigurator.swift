//
//  CommitContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure(atRow row: Int) -> UIContextMenuConfiguration? {
        if let viewController = viewController as? CommitViewController {
            let actionProvider = CommitCellActionProvider(openInSafari: { viewController.openInSafari(atRow: row) },
                                                          share: { viewController.share(atRow: row) })
            return ContextMenuConfigurationConstants.CommitCellConfiguration(with: actionProvider)
        }
        return nil
    }
    
}

