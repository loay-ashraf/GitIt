//
//  SeachHistoryCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewCellConfigurator: TableViewCellConfigurator {
    
    override func configure<T: TableCellViewModel>(_ cell: UITableViewCell, forDisplaying item: T) {
        if let cell = cell as? SearchHistoryTableViewCell, let item = item as? QueryCellViewModel {
            cell.historyLabel.text = item.query
            cell.setNeedsLayout()
        }
    }
    
}
