//
//  OrganizationDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewDelegate: TableViewDelegate<OrganizationTableCellViewModel> {

    override init() {
        super.init()
        tapResponder = OrganizationTableViewTapResponder()
        contextMenuConfigurator = OrganizationTableViewContextMenuConfigurator()
    }

}

class OrganizationCollectionViewDelegate: CollectionViewDelegate<OrganizationCollectionCellViewModel> {
    
    override init() {
        let tapResponder = OrganizationCollectionViewTapResponder()
        let contextMenuConfigurator = OrganizationCollectionViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
