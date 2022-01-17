//
//  TableViewDataSource.swift
//  GitIt
//
//  Created by Loay Ashraf on 16/01/2022.
//

import UIKit

class TableViewDataSource<Type>: NSObject, UITableViewDataSource {
    
    var model: List<Type>!
    var cellConfigurator: TableViewCellConfigurator!
    
    func registerCell(tableView: SFDynamicTableView) { /*override this method in sub class to register cells*/ }
    
    // MARK: - Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableView = tableView as? SFDynamicTableView {
            if let refreshControl = tableView.refreshControl, refreshControl.isRefreshing { return UITableViewCell() }
            if tableView.registeredCellIdentifiers.isEmpty {
                registerCell(tableView: tableView)
            }
            if let cellIdentifier = tableView.registeredCellIdentifiers.first {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! IBTableViewCell
                let item = model.items[indexPath.row]
                
                // Configure the cell...
                cellConfigurator.configure(cell, forDisplaying: item)

                return cell
            }
        }
        return UITableViewCell()
    }
    
}
