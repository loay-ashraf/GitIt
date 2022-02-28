//
//  DPSFDynamicTableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import UIKit

class DPSFDynamicTableViewController<T: DataPersistenceTableViewModel>: UITableViewController {
    
    // MARK: - Properties
    
    var xTableView: DPSFDynamicTableView! { return tableView as? DPSFDynamicTableView }

    var tableViewDataSource: TableViewDataSource<T.TableCellViewModelType>!
    var tableViewDelegate: TableViewDelegate!
    
    var viewModel: T!
    var emptyViewModel: EmptyViewModel = EmptyConstants.General.viewModel
    
    // MARK: - Initialization
    
    deinit {
        xTableView?.transition(to: .presenting)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        if xTableView == nil {
            // re-initialize table view with SFDynamic table view initializer
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            tableView = DPSFDynamicTableView(frame: window!.bounds, style: .plain)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switch xTableView.state {
        case .presenting: enableSearchBar()
        default: disableSearchBar()
        }
    }

    // MARK: - View Helper Methods
    
    func configureView() {
        // Setup table view data source and delegates
        xTableView.setDataSource(tableViewDataSource)
        xTableView.setDelegate(tableViewDelegate)
        // Setup table view header, footer and content insets
        if xTableView.tableHeaderView == nil { xTableView.tableHeaderView = UIView() }
        if xTableView.tableFooterView == nil { xTableView.tableFooterView = UIView() }
    }
    
    func updateView() {
        xTableView.reloadData()
    }
    
    func enableSearchBar() {
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
    }
    
    func disableSearchBar() {
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = false
    }
    
    func enableBouncing() {
        xTableView.bounces = true
    }
    
    func disableBouncing() {
        xTableView.bounces = false
    }
    
}
