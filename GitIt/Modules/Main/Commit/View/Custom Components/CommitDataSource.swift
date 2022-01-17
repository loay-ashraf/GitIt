//
//  CommitDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewDataSource: TableViewDataSource<CommitModel> {
    
    override init() {
        super.init()
        model = List<CommitModel>()
        cellConfigurator = CommitTableViewCellConfigurator()
    }
    
    override func registerCell(tableView: SFDynamicTableView) {
        let nib = CommitTableViewCell.nib
        let resuseIdentifier = CommitTableViewCell.reuseIdentifier
        tableView.register(nib, forCellReuseIdentifier: resuseIdentifier)
    }
    
}
