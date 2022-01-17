//
//  RepositoryDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDelegate: TableViewDelegate<RepositoryModel> {
    
    override init() {
        super.init()
        model = List<RepositoryModel>()
        detailViewControllerPresenter = RepositoryTableViewDetailPresenter()
        contextMenuConfigurator = TableViewContextMenuConfigurator()
    }
    
}
