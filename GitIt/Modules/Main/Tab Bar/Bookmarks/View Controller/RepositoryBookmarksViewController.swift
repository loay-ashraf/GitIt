//
//  RepositoryBookmarksViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import UIKit

class RepositoryBookmarksViewController: DPSFDynamicTableViewController<RepositoryBookmarksViewModel> {
    
    // MARK: - Properties
    
    weak var bookmarksViewController: BookmarksViewController?
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableViewDataSource = RepositoryTableViewDataSource()
        tableViewDelegate = RepositoryBookmarksDelegate(self)
        viewModel = RepositoryBookmarksViewModel()
        emptyViewModel = EmptyConstants.Bookmarks.viewModel
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synchronize()
    }
    
    // MARK: - View Actions
    
    func clear() {
        viewModel.clear()
        synchronize()
    }
    
    func showDetail(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModels[row]
        let detailVC = RepositoryDetailViewController.instatiate(tableCellViewModel: cellViewModelItem)
        NavigationRouter.push(viewController: detailVC)
    }
    
    func toggleBookmark(atRow row: Int) {
        viewModel.toggleBookmark(atRow: row)
        synchronize()
    }
    
    func openInSafari(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModels[row]
        URLHelper.openWebsite(cellViewModelItem.htmlURL)
    }
    
    func share(atRow row: Int) {
        let cellViewModelItem = viewModel.cellViewModels[row]
        URLHelper.shareWebsite(cellViewModelItem.htmlURL)
    }
    
    // MARK: - Synchronize Method
    
    override func synchronize() {
        super.synchronize()
        if viewModel.isEmpty {
            bookmarksViewController?.clearButton.isEnabled = false
        } else {
            bookmarksViewController?.clearButton.isEnabled = true
        }
    }
    
}
