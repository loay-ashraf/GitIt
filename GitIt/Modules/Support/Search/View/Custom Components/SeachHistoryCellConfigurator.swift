//
//  SeachHistoryCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 17/01/2022.
//

import UIKit

class SearchHistoryTableViewCellConfigurator: TableViewCellConfigurator {
    
    func configure<Type>(_ cell: UITableViewCell, forDisplaying item: Type) {
        if let cell = cell as? HistoryTableViewCell, let item = item as? String {
            cell.historyLabel.text = item
            cell.setNeedsLayout()
        }
    }
    
}
