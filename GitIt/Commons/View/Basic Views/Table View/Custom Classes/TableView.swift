//
//  TableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class TableView: UITableView {
    
    // MARK: - Properties
    
    var registeredCells = [TableViewCell.Type]()
    
    // MARK: - Data Source and Delegate Methods
    
    func setDataSource<T: TableCellViewModel>(_ dataSource: TableViewDataSource<T>) {
        self.dataSource = dataSource
        dataSource.tableView = self
    }
    
    func setDelegate(_ delegate: TableViewDelegate) {
        self.delegate = delegate
        delegate.tableView = self
    }
    
    // MARK: - Cell Methods
    
    func registerClass<T: TableViewCell>(cellClass: T.Type) {
        if !registeredCells.contains(where: { $0 == cellClass }) {
            register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
            registeredCells.append(cellClass)
        }
    }
    
    func registerNib<T: TableViewCell>(cellClass: T.Type) {
        if !registeredCells.contains(where: { $0 == cellClass }) {
            register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
            registeredCells.append(cellClass)
        }
    }
    
    func dequeue<T: TableViewCell>(cellClass: T.Type) -> T? {
        if registeredCells.contains(where: { $0 == cellClass }) {
            return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier) as? T
        }
        return nil
    }
    
    func dequeue<T: TableViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        if registeredCells.contains(where: { $0 == cellClass }) {
            return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! T
        }
        return TableViewCell() as! T
    }
    
}

