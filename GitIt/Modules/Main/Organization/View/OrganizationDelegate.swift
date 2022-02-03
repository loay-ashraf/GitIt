//
//  OrganizationDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewDelegate: TableViewDelegate<OrganizationModel> {
    
    override init() {
        super.init()
        tapResponder = OrganizationTableViewTapResponder()
        contextMenuConfigurator = OrganizationTableViewContextMenuConfigurator()
    }
    
}

class dcf: TableViewDelegate<OrganizationCellViewModel> {
    
    override init() {
        super.init()
        tapResponder = OrganizationTableViewTapResponder()
        contextMenuConfigurator = OrganizationTableViewContextMenuConfigurator()
    }
    
}

class OrganizationCollectionViewDelegate: CollectionViewDelegate<OrganizationModel> {
    
    override init() {
        let tapResponder = OrganizationCollectionViewTapResponder()
        let contextMenuConfigurator = OrganizationCollectionViewContextMenuConfigurator()
        super.init(tapResponder: tapResponder, contextMenuConfigurator: contextMenuConfigurator, scrollViewAction: nil)
    }
    
}
