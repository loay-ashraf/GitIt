//
//  OrganizationDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewDataSource: TableViewDataSource<OrganizationModel> {
    
    override init() {
        let cellClass = RoundedImageTableViewCell.self
        let cellConfigurator = OrganizationTableViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator, swipeResponder: nil)
    }
    
}

class OrganizationCollectionViewDataSource: CollectionViewDataSource<OrganizationModel> {
    
    override init() {
        let cellClass = RoundedImageCollectionViewCell.self
        let cellConfigurator = OrganizationCollectionViewCellConfigurator()
        super.init(cellClass: cellClass, cellConfigurator: cellConfigurator)
    }
    
}
