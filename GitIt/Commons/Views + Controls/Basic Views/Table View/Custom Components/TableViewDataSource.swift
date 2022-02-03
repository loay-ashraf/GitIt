//
//  TableViewDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewDataSource<Type>: NSObject, UITableViewDataSource {
    
    var model = List<Type>()
    var viewModels = List<Type>()
    weak var tableView: TableView! { didSet { registerCell() } }
    var cellClass: TableViewCell.Type!
    var cellConfigurator: TableViewCellConfigurator!
    var swipeResponder: TableViewSwipeResponder!
    
    // MARK: - Initialisation
    
    override init() {
        super.init()
        self.cellClass = TableViewCell.self
        self.cellConfigurator = TableViewCellConfigurator()
        self.swipeResponder = TableViewSwipeResponder()
    }
    
    init(cellClass: TableViewCell.Type, cellConfigurator: TableViewCellConfigurator, swipeResponder: TableViewSwipeResponder?) {
        super.init()
        self.cellClass = cellClass
        self.cellConfigurator = cellConfigurator
        self.swipeResponder = swipeResponder
    }
    
    func registerCell() {
        tableView.registerNib(cellClass: cellClass)
    }
    
    // MARK: - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let refreshControl = tableView.refreshControl, refreshControl.isRefreshing { return TableViewCell() }
        let cell = self.tableView.dequeue(cellClass: cellClass, for: indexPath)
        let item = viewModels.items[indexPath.row]
                
        // Configure the cell...
        cellConfigurator.configure(cell, forDisplaying: item)

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let item = model.items[indexPath.row]
        swipeResponder.respondToSwipe(tableView: tableView, editingStyle: editingStyle, indexPath: indexPath, with: item)
    }
    
}
