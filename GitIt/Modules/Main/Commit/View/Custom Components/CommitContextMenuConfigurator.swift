//
//  CommitContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure<Type>(with item: Type) -> UIContextMenuConfiguration {
        return ContextMenuConfigurationConstants.bookmarkAndShareConfiguration(for: item as! CommitModel)
    }
    
}

