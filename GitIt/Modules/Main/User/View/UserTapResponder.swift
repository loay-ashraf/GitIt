//
//  UserTapResponder.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewTapResponder: TableViewTapResponder {
    
    init() {
        super.init(viewControllerClass: UserDetailViewController.self)
    }
    
}

class UserCollectionViewTapResponder: CollectionViewTapResponder {
    
    init() {
        super.init(viewControllerClass: UserDetailViewController.self)
    }
    
}
