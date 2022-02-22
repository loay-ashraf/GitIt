//
//  WSSFDynamicCollectionViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 29/12/2021.
//

import UIKit

class WSSFDynamicCollectionViewController<T: WebServiceCollectionViewModel>: UICollectionViewController {
    
    // MARK: - Properties
    
    var xCollectionView: WSSFDynamicCollectionView! { return collectionView as? WSSFDynamicCollectionView }
    
    var collectionViewDataSource: CollectionViewDataSource<T.CollectionCellViewModelType>!
    var collectionViewDelegate: CollectionViewDelegate!
    
    var viewModel: T!
    var emptyViewModel: EmptyViewModel = Constants.View.Empty.General.viewModel
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        if xCollectionView == nil {
            // re-initialize table view with SFDynamic table view initializer
            let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first
            collectionView = WSSFDynamicCollectionView(frame: window!.bounds, collectionViewLayout: UICollectionViewLayout())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // MARK: - View Helper Methods
    
    func configureView() {
        // Setup collection data source and delegates
        xCollectionView.setDataSource(collectionViewDataSource)
        xCollectionView.setDelegate(collectionViewDelegate)
        // Setup collection view refresh control
        xCollectionView.refreshControl = UIRefreshControl()
        xCollectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        // Setup error actions
        xCollectionView.errorAction = { [weak self] in self?.load(with: .initial) }
    }
    
    func updateView() {
        synchronizeCollectionView()
        xCollectionView.reloadData()
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
        } else if viewModel.isEmpty {
            xCollectionView.transition(to: .empty(emptyViewModel))
            disableSearchBar()
        } else {
            synchronizeCollectionView()
            xCollectionView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func refreshHandler(error: Error?) {
        if let error = error {
            xCollectionView.transition(to: .failed(.refresh(error)))
            disableSearchBar()
        } else {
            synchronizeCollectionView()
            xCollectionView.transition(to: .presenting)
            enableSearchBar()
        }
    }
    
    func resetHandler() {
        xCollectionView.transition(to: .presenting)
        enableSearchBar()
    }
    
    // MARK: - Collection View Synchronization Methods
    
    func synchronizeCollectionView() {
        collectionViewDataSource.cellViewModels = viewModel.items
    }

}
