//
//  SFDynamicTableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import UIKit

class SFDynamicTableViewController<Type>: UITableViewController {
    
    var xTableView: SFDynamicTableView! { return tableView as? SFDynamicTableView }

    var tableViewDataSource: TableViewDataSource<Type>!
    var tableViewDelegate: TableViewDelegate<Type>!
    
    private(set) var model: List<Type>!
    private(set) var emptyViewModel: EmptyViewModel = EmptyConstants.General.viewModel
    
    // MARK: - Initialisation
    
    init(tableViewDataSource: TableViewDataSource<Type>, tableViewDelegate: TableViewDelegate<Type>) {
        super.init(nibName: nil, bundle: nil)
        self.model = List<Type>()
        self.tableViewDataSource = tableViewDataSource
        self.tableViewDelegate = tableViewDelegate
        
    }
    
    init?(coder: NSCoder, tableViewDataSource: TableViewDataSource<Type>, tableViewDelegate: TableViewDelegate<Type>) {
        super.init(coder: coder)
        self.model = List<Type>()
        self.tableViewDataSource = tableViewDataSource
        self.tableViewDelegate = tableViewDelegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        if xTableView == nil {
            // re-initialize table view with SFDynamic table view initializer
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            tableView = SFDynamicTableView(frame: window!.bounds, style: .plain)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        xTableView.transition(to: .presenting)
    }

    // MARK: - View Helper Methods
    
    func configureView() {
        // Setup table view as super view
        xTableView.isSuperView = true
        // Setup table view data source and delegates
        xTableView.setDataSource(tableViewDataSource)
        xTableView.setDelegate(tableViewDelegate)
        tableViewDelegate.scrollViewAction = { [weak self] in if (self?.model.count) ?? 0 > 0 { self?.paginate() } }
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
        synchronizeTableView()
        xTableView.reloadData()
    }
    
    func enableSearchBar() {
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
        navigationItem.searchController?.searchBar.alpha = 1.0
    }
    
    func disableSearchBar() {
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = false
        navigationItem.searchController?.searchBar.alpha = 0.5
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
        xTableView.transition(to: .loading(loadingViewState))
    }
    
    @objc func refresh() {
        load(with: .refresh)
    }
    
    func paginate() {
        let lastRowIndex = tableView.indexPathsForVisibleRows?.last?.row
        if let lastRowIndex = lastRowIndex {
            if model.isPaginable, lastRowIndex + 1 == model.count {
                switch self.xTableView.state {
                case .presenting: load(with: .paginate)
                default: break
                }
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
        } else if model.isEmpty {
            xTableView.transition(to: .empty(emptyViewModel))
            disableSearchBar()
        } else {
            synchronizeTableView()
            xTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func refreshHandler(error: Error?) {
        if let error = error {
            xTableView.transition(to: .failed(.refresh(error)))
            disableSearchBar()
        } else {
            synchronizeTableView()
            xTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func paginateHandler(error: Error?) {
        if let error = error {
            xTableView.transition(to: .failed(.paginate(error)))
            disableSearchBar()
        } else {
            synchronizeTableView()
            xTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func resetHandler() {
        xTableView.transition(to: .presenting)
        enableSearchBar()
    }
    
    func synchronizeTableView() {
        tableViewDataSource.model = model
        tableViewDelegate.model = model
    }
    
}
