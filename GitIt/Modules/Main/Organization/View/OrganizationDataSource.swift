//
//  OrganizationDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class OrganizationTableViewDataSource: TableViewDataSource<OrganizationModel> {
    
    override init() {
        super.init()
        model = List<OrganizationModel>()
        cellConfigurator = OrganizationTableViewCellConfigurator()
    }
    
    override func registerCell(tableView: SFDynamicTableView) {
        let nib = RoundedImageTableViewCell.nib
        let resuseIdentifier = RoundedImageTableViewCell.reuseIdentifier
        tableView.register(nib, forCellReuseIdentifier: resuseIdentifier)
    }
    
}
