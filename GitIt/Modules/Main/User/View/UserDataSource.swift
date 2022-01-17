//
//  UserDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewDataSource: TableViewDataSource<UserModel> {
    
    override init() {
        super.init()
        model = List<UserModel>()
        cellConfigurator = UserTableViewCellConfigurator()
    }
    
    override func registerCell(tableView: SFDynamicTableView) {
        let nib = RoundedImageTableViewCell.nib
        let resuseIdentifier = RoundedImageTableViewCell.reuseIdentifier
        tableView.register(nib, forCellReuseIdentifier: resuseIdentifier)
    }
    
}
