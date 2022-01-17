//
//  SearchHistoryDelegate.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDelegate: TableViewDelegate<String> {
    
    override init() {
        super.init()
        model = List<String>()
        detailViewControllerPresenter = UserTableViewDetailPresenter()
        contextMenuConfigurator = nil
    }
    
}
