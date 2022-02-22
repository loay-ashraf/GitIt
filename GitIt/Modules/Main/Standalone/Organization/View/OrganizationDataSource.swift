//
//  OrganizationDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewDataSource: SKTableViewDataSource<OrganizationTableCellViewModel> {
    
    override init() {
        super.init()
        cellClass = BasicTableViewCell.self
        cellConfigurator = OrganizationTableViewCellConfigurator()
    }
    
}

class OrganizationCollectionViewDataSource: CollectionViewDataSource<OrganizationCollectionCellViewModel> {
    
    override init() {
        super.init()
        cellClass = BasicCollectionViewCell.self
        cellConfigurator = OrganizationCollectionViewCellConfigurator()
    }
    
}
