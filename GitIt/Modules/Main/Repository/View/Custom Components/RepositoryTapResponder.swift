//
//  RepositoryDetailPresenter.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class RepositoryTableViewTapResponder: TableViewTapResponder {
    
    init() {
        super.init(viewControllerClass: RepositoryDetailViewController.self)
    }
    
}

class RepositoryCollectionViewTapResponder: CollectionViewTapResponder {
    
    init() {
        super.init(viewControllerClass: RepositoryDetailViewController.self)
    }
    
}
