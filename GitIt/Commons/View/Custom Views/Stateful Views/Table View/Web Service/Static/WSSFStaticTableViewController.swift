//
//  WSSFStaticTableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 28/12/2021.
//

import UIKit

class WSSFStaticTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var xTableView: WSSFStaticTableView! { return tableView as? WSSFStaticTableView }
    
    // MARK: - Initialization
    
    deinit {
        xTableView?.transition(to: .presenting)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        fitTableHeaderView()
        fitTableFooterView()
    }

    // MARK: - View Helper Methods
    
    func configureView() {
        // Setup table view as super view
        xTableView.isSuperView = true
        // Setup actions
        xTableView.updateView = { [weak self] in self?.updateView() }
        xTableView.errorAction = { [weak self] in self?.load() }
    }
    
    func updateView() { /* Override this method in subclass to provide view updater method */ }
    
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

    // MARK: - Load, Refresh and Paginate Methods
    
    func load() {
        xTableView.transition(to: .loading(.initial))
    }
    
    // MARK: - Load, Refresh and Paginate Handlers
    
    func loadHandler(error: Error?) {
        if let error = error {
            xTableView.transition(to: .failed(.initial(error)))
        } else {
            xTableView.transition(to: .presenting)
        }
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showViewController(forRowAt: indexPath)
    }
    
}
