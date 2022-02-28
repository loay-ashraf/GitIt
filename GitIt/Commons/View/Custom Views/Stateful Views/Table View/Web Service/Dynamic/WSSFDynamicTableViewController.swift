//
//  WSSFDynamicTableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import UIKit

class WSSFDynamicTableViewController<T: WebServiceTableViewModel>: UITableViewController {
    
    // MARK: - Properties
    
    var xTableView: WSSFDynamicTableView! { return tableView as? WSSFDynamicTableView }

    var tableViewDataSource: TableViewDataSource<T.TableCellViewModelType>!
    var tableViewDelegate: TableViewDelegate!
    
    var viewModel: T!
    var emptyViewModel: EmptyViewModel = EmptyConstants.General.viewModel
    
    var didLoadInitial: Bool = false
    
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
            tableView = WSSFDynamicTableView(frame: window!.bounds, style: .plain)
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
        tableViewDelegate.scrollViewAction = { [weak self] in if (self?.viewModel.count) ?? 0 > 0 { self?.paginate() } }
        // Setup table view header, footer and content insets
        if xTableView.tableHeaderView == nil { xTableView.tableHeaderView = UIView() }
        if xTableView.tableFooterView == nil { xTableView.tableFooterView = UIView() }
        // Setup table view refresh control
        xTableView.refreshControl = UIRefreshControl()
        xTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // Setup error actions
        xTableView.errorAction = { [weak self] in self?.load(with: .initial) }
        xTableView.footerErrorAction = { [weak self] in self?.load(with: .paginate) }
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
    
    func enableRefreshControl() {
        xTableView.refreshControl = UIRefreshControl()
        xTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func disableRefreshControl() {
        xTableView.refreshControl = nil
    }
    
    func enableBouncing() {
        xTableView.bounces = true
    }
    
    func disableBouncing() {
        xTableView.bounces = false
    }
    
    // MARK: - Load, Refresh, Paginate and Reset Methods
    
    func load(with loadingViewState: LoadingViewState) {
        if loadingViewState == .initial, didLoadInitial { return }
        xTableView.transition(to: .loading(loadingViewState))
    }
    
    @objc func refresh() {
        load(with: .refresh)
    }
    
    func paginate() {
        let lastRowIndex = tableView.indexPathsForVisibleRows?.last?.row
        if let lastRowIndex = lastRowIndex {
            if viewModel.isPaginable, xTableView.state == .presenting, lastRowIndex + 1 == viewModel.count {
                load(with: .paginate)
            }
        }
    }
    
    func reset() {
        xTableView.transition(to: .loading(.initial))
    }
    
    // MARK: - Load, Refresh, Paginate and Reset Handlers
    
    func loadHandler(error: Error?) {
        if let error = error {
            xTableView.transition(to: .failed(.initial(error)))
            disableSearchBar()
        } else if viewModel.isEmpty {
            xTableView.transition(to: .empty(emptyViewModel))
            disableSearchBar()
        } else {
            xTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func refreshHandler(error: Error?) {
        if let error = error {
            xTableView.transition(to: .failed(.refresh(error)))
            disableSearchBar()
        } else {
            xTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func paginateHandler(error: Error?) {
        if let error = error {
            xTableView.transition(to: .failed(.paginate(error)))
            disableSearchBar()
        } else {
            xTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func resetHandler() {
        xTableView.transition(to: .presenting)
        enableSearchBar()
    }
    
}
