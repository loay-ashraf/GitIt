//
//  HistoryTableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/11/2021.
//

import UIKit

class HistoryTableViewController: SFDynamicTableViewController<String> {
    
    override var model: List<String>! { return delegate?.keywords }
    //override var cellConfigurator: TableViewCellConfigurator! { return HistoryTableViewCellConfigurator() }
    
    weak var delegate: HistoryTableDelegate!
    
    // MARK: - Initialisation
    
    deinit {
        print("Controller deallocated")
    }
    
    // MARK: - View Helper Methods
    
    override func configureView() {
        super.configureView()
        registerCell(cellType: HistoryTableViewCell.self)
        xTableView.cornerRadius = 10.0
        xTableView.cornerCurve = .continuous
        disableRefreshControl()
        disableBouncing()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let selectedKeyword = model.items[indexPath.row]
        delegate.add(keyWord: selectedKeyword)
        updateView()
        delegate.didUpdateTable()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectedKeyword = model.items[indexPath.row]
        if editingStyle == .delete {
            delegate.delete(keyWord: selectedKeyword)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            delegate.didUpdateTable()
        }
    }
    
}
