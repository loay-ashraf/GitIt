//
//  DPSFStaticTableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import UIKit

class DPSFStaticTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var xTableView: DPSFStaticTableView! { return tableView as? DPSFStaticTableView }
    
    // MARK: - Initialization
    
    deinit {
        xTableView?.transition(to: .presenting)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fitTableHeaderView()
        fitTableFooterView()
    }
    
    func fitTableHeaderView() {
        guard let headerView = xTableView.tableHeaderView else {
            return
        }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            xTableView.tableHeaderView = headerView
            xTableView.layoutIfNeeded()
        }
    }
    
    func fitTableFooterView() {
        guard let footerView = tableView.tableFooterView else {
            return
        }
        let size = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if footerView.frame.size.height != size.height {
            footerView.frame.size.height = size.height
            tableView.tableFooterView = footerView
            tableView.layoutIfNeeded()
        }
    }
    
    // MARK: - View Action Methods
    
    func showViewController(forRowAt indexPath: IndexPath) {
        xTableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Synchronize Method
    
    func synchronize() { /* Override this method in subclass to provide synchronization method */ }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showViewController(forRowAt: indexPath)
    }
    
}
