//
//  CommitTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewTapResponder: TableViewTapResponder {
    
    override func respondToTap(atRow row: Int) {
        if let viewController = viewController as? CommitViewController {
            viewController.showDetail(atRow: row)
        }
    }
    
}
