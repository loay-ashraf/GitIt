//
//  UserDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewDelegate: TableViewDelegate<UserModel> {
    
    override init() {
        super.init()
        model = List<UserModel>()
        detailViewControllerPresenter = UserTableViewDetailPresenter()
        contextMenuConfigurator = UserTableViewContextMenuConfigurator()
    }
    
}
