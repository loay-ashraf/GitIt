//
//  UserDetailPresenter.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class UserTableViewDetailPresenter: TableViewDetailPresenter {
    
    override init() {
        super.init()
        viewControllerClass = UserDetailViewController.self
    }
    
}
