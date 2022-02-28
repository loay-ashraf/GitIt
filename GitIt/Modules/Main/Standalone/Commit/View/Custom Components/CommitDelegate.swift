//
//  CommitDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewDelegate: TableViewDelegate {
    
    init(_ viewController: CommitViewController) {
        super.init()
        tapResponder = CommitTableViewTapResponder(viewController)
        contextMenuConfigurator = CommitTableViewContextMenuConfigurator(viewController)
    }
    
}
