//
//  TableViewCellConfigurator.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewCellConfigurator {
    
    func configure<T: TableCellViewModel>(_ cell: UITableViewCell, forDisplaying item: T) { /* override this method in sub classes */ }
    
}
