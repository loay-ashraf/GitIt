//
//  CommitDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewDelegate: TableViewDelegate<CommitCellViewModel> {
    
    override init() {
        super.init()
        tapResponder = CommitTableViewTapResponder()
        contextMenuConfigurator = CommitTableViewContextMenuConfigurator()
    }
    
}
