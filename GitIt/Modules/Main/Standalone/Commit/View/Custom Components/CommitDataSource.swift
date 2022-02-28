//
//  CommitDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewDataSource: SKTableViewDataSource<CommitCellViewModel> {
    
    override init() {
        super.init()
        cellClass = CommitTableViewCell.self
        cellConfigurator = CommitTableViewCellConfigurator()
    }
    
}
