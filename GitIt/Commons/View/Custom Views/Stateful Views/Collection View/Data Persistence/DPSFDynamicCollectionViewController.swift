//
//  DPSFDynamicCollectionViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 22/02/2022.
//

import UIKit

class DPSFDynamicCollectionViewController<T: DataPersistenceCollectionViewModel>: UICollectionViewController {
    
    // MARK: - Properties
    
    var xCollectionView: DPSFDynamicCollectionView! { return collectionView as? DPSFDynamicCollectionView }
    
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
            collectionView = DPSFDynamicCollectionView(frame: window!.bounds, collectionViewLayout: UICollectionViewLayout())
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
    }
    
    func updateView() {
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

}
