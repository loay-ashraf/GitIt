//
//  SFDynamicTableViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 27/12/2021.
//

import UIKit

class SFDynamicTableViewController<Type: Model>: UITableViewController {
    
    var dynamicTableView: SFDynamicTableView! { return tableView as? SFDynamicTableView }
    
    var cellType: IBTableViewCell.Type!
    var detailViewControllerType: IBViewController.Type!
    
    private(set) var model: List<Type>!
    
    // MARK: - Initialisation
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        model = List<Type>()
        cellType = Constants.Model.modelToCellType(type: Type.self)
        detailViewControllerType = Constants.Model.modelToDetailViewControllerType(type: Type.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
        tableView = SFDynamicTableView(frame: window!.bounds, style: .plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - View Helper Methods
    
    func configureView() {
        dynamicTableView.dataSource = self
        dynamicTableView.delegate = self
        dynamicTableView.errorAction = { [weak self] in self?.load(with: .initial) }
        dynamicTableView.footerErrorAction = { [weak self] in self?.load(with: .paginate) }
        dynamicTableView.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
        dynamicTableView.tableHeaderView = UIView()
        dynamicTableView.tableFooterView = UIView()
        dynamicTableView.refreshControl = UIRefreshControl()
        dynamicTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // View bounds compensation for right positioning of loading indicators
        if let navigationController = navigationController { view.bounds.size.height -= navigationController.navigationBar.frame.height }
        if let tabBarController = tabBarController { view.bounds.size.height -= tabBarController.tabBar.frame.height }
    }
    
    func configureContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let modelItem = model.items[indexPath.row]
        return Constants.Model.modelToContextMenuConfiguration(type: Type.self, for: modelItem)!
    }
    
    func enableSearchBar() {
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = true
        navigationItem.searchController?.searchBar.alpha = 1.0
    }
    
    func disableSearchBar() {
        navigationItem.searchController?.searchBar.isUserInteractionEnabled = false
        navigationItem.searchController?.searchBar.alpha = 0.5
    }
    
    // MARK: - Load, Refresh and Paginate Methods
    
    func load(with loadingViewState: LoadingViewState) {
        dynamicTableView.transition(to: .loading(loadingViewState))
    }
    
    @objc func refresh() {
        load(with: .refresh)
    }
    
    func paginate() {
        let lastRowIndex = tableView.indexPathsForVisibleRows?.last?.row
        if let lastRowIndex = lastRowIndex {
            if model.isPaginable, lastRowIndex + 1 == model.items.count {
                switch self.dynamicTableView.state {
                case .loading, .failed: return
                default: load(with: .paginate)
                }
            }
        }
    }
    
    // MARK: - Load, Refresh and Paginate Handlers
    
    func loadHandler(error: Error?) {
        if let error = error {
            dynamicTableView.transition(to: .failed(.initial(error)))
            disableSearchBar()
        } else {
            dynamicTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func refreshHandler(error: Error?) {
        if let error = error {
            dynamicTableView.transition(to: .failed(.refresh(error)))
            disableSearchBar()
        } else {
            dynamicTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func paginateHandler(error: Error?) {
        if let error = error {
            dynamicTableView.transition(to: .failed(.paginate(error)))
            disableSearchBar()
        } else {
            dynamicTableView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.refreshControl!.isRefreshing { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! IBTableViewCell
        let item = model.items[indexPath.row]
        
        // Configure the cell...
        cell.configure(with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let modelItem = model.items[indexPath.row]
        let detailVC = detailViewControllerType.instatiateFromStoryboard(with: modelItem)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(indexPath: indexPath)
    }
    
    // MARK: - Scroll View Delegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        paginate()
    }
    
}
