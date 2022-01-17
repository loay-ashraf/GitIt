//
//  SearchHistoryDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewDataSource: TableViewDataSource<String> {
    
    override init() {
        super.init()
        model = List<String>()
        cellConfigurator = SearchHistoryTableViewCellConfigurator()
    }
    
    override func registerCell(tableView: SFDynamicTableView) {
        let nib = HistoryTableViewCell.nib
        let resuseIdentifier = HistoryTableViewCell.reuseIdentifier
        tableView.register(nib, forCellReuseIdentifier: resuseIdentifier)
    }
    
}
