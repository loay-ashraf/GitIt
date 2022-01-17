//
//  UserContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewContextMenuConfigurator: TableViewContextMenuConfigurator {
    
    override func configure<Type>(with item: Type) -> UIContextMenuConfiguration {
        if let configuration = Constants.Model.contextMenuConfiguration(for: item) {
            return configuration
        }
        return UIContextMenuConfiguration()
    }
    
}

