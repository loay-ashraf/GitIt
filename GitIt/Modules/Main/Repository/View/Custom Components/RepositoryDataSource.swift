//
//  RepositoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDataSource: TableViewDataSource<RepositoryModel> {
    
    override init() {
        super.init()
        model = List<RepositoryModel>()
        cellConfigurator = RepositoryTableViewCellConfigurator()
    }
    
    override func registerCell(tableView: SFDynamicTableView) {
        let nib = RepositoryTableViewCell.nib
        let resuseIdentifier = RepositoryTableViewCell.reuseIdentifier
        tableView.register(nib, forCellReuseIdentifier: resuseIdentifier)
    }
    
}
