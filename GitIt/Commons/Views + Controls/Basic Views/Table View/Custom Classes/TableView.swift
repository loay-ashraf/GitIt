//
//  TableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class TableView: UITableView {
    
    var registeredCells = [TableViewCell.Type]()
    
    func setDataSource<T: TableCellViewModel>(_ dataSource: TableViewDataSource<T>) {
        self.dataSource = dataSource
        dataSource.tableView = self
    }
    
    func setDelegate<T: TableCellViewModel>(_ delegate: TableViewDelegate<T>) {
        self.delegate = delegate
        delegate.tableView = self
    }
    
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
