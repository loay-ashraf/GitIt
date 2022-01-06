//
//  SFDynamicTableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import UIKit

class SFDynamicTableViewController<Type>: UITableViewController {
    
    var xTableView: SFDynamicTableView! { return tableView as? SFDynamicTableView }
    
    var cellType: IBTableViewCell.Type!
    var detailViewControllerType: IBViewController.Type?

    private(set) var model: List<Type>!
    
    // MARK: - Initialisation
    
    init(cellType: IBTableViewCell.Type, detailViewControllerType: IBViewController.Type? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.cellType = cellType
        self.detailViewControllerType = detailViewControllerType
        self.model = List<Type>()
    }
    
    override private init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
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

    // MARK: - View Helper Methods
    
    func configureView() {
        // Setup table view cell, data source and delegates
        if let cellType = cellType, xTableView.registeredNibs.isEmpty, xTableView.registeredCellIdentifiers.isEmpty {
            xTableView.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
        xTableView.dataSource = self
        xTableView.delegate = self
        if xTableView.tableHeaderView == nil { xTableView.tableHeaderView = UIView() }
        if xTableView.tableFooterView == nil { xTableView.tableFooterView = UIView() }
        xTableView.refreshControl = UIRefreshControl()
        xTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // Setup error actions
        xTableView.errorAction = { [weak self] in self?.load(with: .initial) }
        xTableView.footerErrorAction = { [weak self] in self?.load(with: .paginate) }
    }
    
    func updateView() {
        xTableView.reloadData()
    }
    
    func registerCell(cellType: IBTableViewCell.Type) {
        xTableView.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let modelItem = model.items[indexPath.row]
        if let configuration = Constants.Model.modelToContextMenuConfiguration(type: Type.self, for: modelItem) {
            return configuration
        }
        return UIContextMenuConfiguration()
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
            if model.isPaginable, lastRowIndex + 1 == model.items.count {
                switch self.xTableView.state {
                case .loading, .failed: return
                default: load(with: .paginate)
                }
            }
        }
    }
    
    func reset() {
        xTableView.transition(to: .loading(.initial))
    }
    
    // MARK: - Load, Refresh, Paginate and Reset Handlers
    
    func loadHandler(error: Error?, emptyContext: EmptyContext?) {
        if let error = error {
            xTableView.transition(to: .failed(.initial(error)))
            disableSearchBar()
        } else if let emptyContext = emptyContext{
            xTableView.transition(to: .empty(emptyContext))
            disableSearchBar()
        } else {
            xTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func refreshHandler(error: Error?, emptyContext: EmptyContext?) {
        if let error = error {
            xTableView.transition(to: .failed(.refresh(error)))
            disableSearchBar()
        } else {
            xTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func paginateHandler(error: Error?, emptyContext: EmptyContext?) {
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
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let refreshControl = xTableView.refreshControl, refreshControl.isRefreshing { return UITableViewCell() }
        if let cellIdentifier = xTableView.registeredCellIdentifiers.first, cellType == nil {
            let cell = xTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! IBTableViewCell
            let item = model.items[indexPath.row]
            
            // Configure the cell...
            cell.configure(with: item)

            return cell
        } else if cellType != nil {
            let cell = xTableView.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! IBTableViewCell
            let item = model.items[indexPath.row]
            
            // Configure the cell...
            cell.configure(with: item)

            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        xTableView.deselectRow(at: indexPath, animated: true)
        if let detailViewControllerType = detailViewControllerType {
            let modelItem = model.items[indexPath.row]
            let detailVC = detailViewControllerType.instatiateWithModel(with: modelItem)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(indexPath: indexPath)
    }
    
    // MARK: - Scroll View Delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        paginate()
    }
    
}
