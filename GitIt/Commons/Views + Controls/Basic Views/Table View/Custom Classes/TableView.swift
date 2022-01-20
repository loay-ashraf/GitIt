//
//  TableView.swift
//  GitIt
//
//  Created by Loay Ashraf on 20/01/2022.
//

import UIKit

class TableView: UITableView {
    
    var registeredCells = [TableViewCell.Type]()
    
    func setDataSource<Type>(_ dataSource: TableViewDataSource<Type>) {
        self.dataSource = dataSource
        dataSource.tableView = self
    }
    
    func setDelegate<Type>(_ delegate: TableViewDelegate<Type>) {
        self.delegate = delegate
        delegate.tableView = self
    }
    
    func registerClass<T: TableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
        registeredCells.append(cellClass)
    }
    
    func registerNib<T: TableViewCell>(cellClass: T.Type) {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
        registeredCells.append(cellClass)
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
