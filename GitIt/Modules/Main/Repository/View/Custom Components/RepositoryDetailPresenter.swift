//
//  RepositoryDetailPresenter.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewDetailPresenter: TableViewDetailPresenter {
    
    override init() {
        super.init()
        viewControllerClass = RepositoryDetailViewController.self
    }
    
}
