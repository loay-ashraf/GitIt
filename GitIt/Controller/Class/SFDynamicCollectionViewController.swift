//
//  SFDynamicCollectionViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/12/2021.
//

import UIKit

class SFDynamicCollectionViewController<Type>: UICollectionViewController {
    
    var xCollectionView: SFDynamicCollectionView! { return collectionView as? SFDynamicCollectionView }
    
    var cellType: IBCollectionViewCell.Type!
    var detailViewControllerType: IBViewController.Type?
    
    private(set) var model: List<Type>!
    
    // MARK: - Initialisation
    
    init(cellType: IBCollectionViewCell.Type, detailViewControllerType: IBViewController.Type? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.cellType = cellType
        self.detailViewControllerType = detailViewControllerType
        self.model = List<Type>()
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        if xCollectionView == nil {
            // re-initialize table view with SFDynamic table view initializer
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            collectionView = SFDynamicCollectionView(frame: window!.bounds, collectionViewLayout: UICollectionViewLayout())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - View Helper Methods
    
    func configureView() {
        // Setup collection view cell, data source and delegates
        if let cellType = cellType, xCollectionView.registeredViews.isEmpty {
            xCollectionView.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
        }
        xCollectionView.dataSource = self
        xCollectionView.delegate = self
        xCollectionView.refreshControl = UIRefreshControl()
        xCollectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // Setup error actions
        xCollectionView.errorAction = { [weak self] in self?.load(with: .initial) }
        // View bounds compensation for right positioning of loading indicators
        if let navigationController = navigationController { view.bounds.size.height -= navigationController.navigationBar.frame.height }
        if let tabBarController = tabBarController { view.bounds.size.height -= tabBarController.tabBar.frame.height }
    }
    
    func updateView() {
        xCollectionView.reloadData()
    }
    
    func registerCell(cellType: IBCollectionViewCell.Type) {
        xCollectionView.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
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
    
    func enableRefreshControl() {
        xCollectionView.refreshControl = UIRefreshControl()
        xCollectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func disableRefreshControl() {
        xCollectionView.refreshControl = nil
    }
    
    func enableBouncing(direction: UICollectionView.ScrollDirection) {
        switch direction {
        case .horizontal: xCollectionView.alwaysBounceHorizontal = true
                          xCollectionView.alwaysBounceVertical = false
        case .vertical: xCollectionView.alwaysBounceVertical = true
                        xCollectionView.alwaysBounceHorizontal = false
        @unknown default: return
        }
    }
    
    func disableBouncing(direction: UICollectionView.ScrollDirection) {
        switch direction {
        case .horizontal: xCollectionView.alwaysBounceHorizontal = false
        case .vertical: xCollectionView.alwaysBounceVertical = false
        @unknown default: return
        }
    }
    
    // MARK: - Load, Refresh and Reset Methods
    
    func load(with loadingViewState: LoadingViewState) {
        xCollectionView.transition(to: .loading(loadingViewState))
    }
    
    @objc func refresh() {
        load(with: .refresh)
    }
    
    func reset() {
        xCollectionView.transition(to: .loading(.initial))
    }
    
    // MARK: - Load, Refresh, Paginate and Reset Handlers
    
    func loadHandler(error: Error?) {
        if let error = error {
            xCollectionView.transition(to: .failed(.initial(error)))
            disableSearchBar()
        } else {
            xCollectionView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func refreshHandler(error: Error?) {
        if let error = error {
            xCollectionView.transition(to: .failed(.refresh(error)))
            disableSearchBar()
        } else {
            xCollectionView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func resetHandler() {
        xCollectionView.transition(to: .presenting)
        enableSearchBar()
    }
    
    // MARK: - Collection View Data Source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.items.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let refreshControl = xCollectionView.refreshControl, refreshControl.isRefreshing { return UICollectionViewCell() }
        if let cellIdentifier = xCollectionView.registeredViews.keys.first {
            let cell = xCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! IBCollectionViewCell
            let item = model.items[indexPath.row]
            
            // Configure the cell...
            cell.configure(with: item)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: - Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        xCollectionView.deselectItem(at: indexPath, animated: true)
        if let detailViewControllerType = detailViewControllerType {
            let modelItem = model.items[indexPath.row]
            let detailVC = detailViewControllerType.instatiateWithModel(with: modelItem)
            if let navigationController = navigationController {
                navigationController.pushViewController(detailVC, animated: true)
            } else if let parent = parent {
                parent.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return configureContextMenu(indexPath: indexPath)
    }

}
