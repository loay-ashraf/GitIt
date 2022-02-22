//
//  TableViewDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit
import SkeletonView

class TableViewDataSource<T: TableCellViewModel>: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    weak var tableView: TableView? { didSet { registerCell() } }
    var cellViewModels = Array<T>()
    var cellClass: TableViewCell.Type?
    var cellConfigurator: TableViewCellConfigurator?
    var swipeResponder: TableViewSwipeResponder?
    
    // MARK: - Cell Registeration Methods
    
    func registerCell() {
        if let tableView = tableView, let cellClass = cellClass {
            tableView.registerNib(cellClass: cellClass)
        }
    }
    
    // MARK: - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let refreshControl = tableView.refreshControl, refreshControl.isRefreshing { return TableViewCell() }
        if let tableView = self.tableView, let cellClass = cellClass, let cellConfigurator = cellConfigurator {
            let cell = tableView.dequeue(cellClass: cellClass, for: indexPath)
            let item = cellViewModels[indexPath.row]
                    
            // Configure the cell...
            cellConfigurator.configure(cell, forDisplaying: item)

            return cell
        }
        return TableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        swipeResponder?.respondToSwipe(editingStyle: editingStyle, atRow: indexPath.row)
    }
    
}

class SKTableViewDataSource<T: TableCellViewModel>: TableViewDataSource<T>, SkeletonTableViewDataSource {
    
    // MARK: - Data Source
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return cellClass?.reuseIdentifier ?? "TableViewCell"
    }
    
}
