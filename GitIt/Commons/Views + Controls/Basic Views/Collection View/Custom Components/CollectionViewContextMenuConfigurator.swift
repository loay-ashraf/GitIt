//
//  CollectionViewContextMenuConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CollectionViewContextMenuConfigurator {
    
    weak var viewController: UIViewController?
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func configure(atItem item: Int) -> UIContextMenuConfiguration? {
        return nil
    }
    
}
