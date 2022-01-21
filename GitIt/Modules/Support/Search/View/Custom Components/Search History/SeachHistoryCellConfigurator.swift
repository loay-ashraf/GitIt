//
//  SeachHistoryCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewCellConfigurator: TableViewCellConfigurator {
    
    override func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? SearchHistoryTableViewCell, let item = item as? String {
            cell.historyLabel.text = item
            cell.setNeedsLayout()
        }
    }
    
}
