//
//  TableViewContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewContextMenuConfigurator {
    
    weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func configure(atRow row: Int) -> UIContextMenuConfiguration? {
        return nil
    }
    
}
