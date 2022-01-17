//
//  CommitDetailPresenter.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class CommitTableViewDetailPresenter: TableViewDetailPresenter {
    
    override init() {
        super.init()
        viewControllerClass = CommitDetailViewController.self
    }
    
}
