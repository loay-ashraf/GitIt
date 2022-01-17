//
//  CommitDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewDelegate: TableViewDelegate<CommitModel> {
    
    override init() {
        super.init()
        model = List<CommitModel>()
        detailViewControllerPresenter = CommitTableViewDetailPresenter()
        contextMenuConfigurator = TableViewContextMenuConfigurator()
    }
    
}
