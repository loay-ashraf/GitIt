//
//  CommitTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewTapResponder: TableViewTapResponder {
    
    init() {
        super.init(viewControllerClass: CommitDetailViewController.self)
    }
    
}
