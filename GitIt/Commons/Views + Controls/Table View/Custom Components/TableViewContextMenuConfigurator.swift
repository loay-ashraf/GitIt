//
//  TableViewContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewContextMenuConfigurator {
    
    func configure<Type>(with item: Type) -> UIContextMenuConfiguration {
        if let configuration = Constants.Model.contextMenuConfiguration(for: item) {
            return configuration
        }
        return UIContextMenuConfiguration()
    }
    
}
