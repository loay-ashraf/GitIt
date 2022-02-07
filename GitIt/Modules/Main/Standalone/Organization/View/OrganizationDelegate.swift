//
//  OrganizationDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewDelegate: TableViewDelegate {
    
    init(_ viewController: OrganizationViewController) {
        super.init()
        tapResponder = OrganizationTableViewTapResponder(viewController)
        contextMenuConfigurator = OrganizationTableViewContextMenuConfigurator(viewController)
    }
    
}

class OrganizationCollectionViewDelegate: CollectionViewDelegate {
    
    init(_ viewController: OrganizationViewController) {
        super.init()
        tapResponder = OrganizationCollectionViewTapResponder(viewController)
        contextMenuConfigurator = OrganizationCollectionViewContextMenuConfigurator(viewController)
    }
    
}
