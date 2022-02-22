//
//  RepositoryBookmarksViewController.swift
//  GitIt
//
//  Created by Loay Ashraf on 21/02/2022.
//

import UIKit

class RepositoryBookmarksViewController: UITableViewController {
    
    // MARK: - Properties
    
    weak var bookmarksViewController: BookmarksViewController?
    
    var xTableView: SFDynamicTableView! { return tableView as? SFDynamicTableView }
    
    var tableViewDataSource = RepositoryTableViewDataSource()
    var tableViewDelegate: RepositoryBookmarksDelegate?
    
    var viewModel = RepositoryBookmarksViewModel()
    var emptyViewModel = EmptyConstants.Bookmarks.viewModel
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        synchronize()
    }
    
    // MARK: - View Helper Methods

    func configureView() {
        tableViewDelegate = RepositoryBookmarksDelegate(self)
        xTableView.setDataSource(tableViewDataSource)
        xTableView.setDelegate(tableViewDelegate!)
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
    
    // MARK: - Synchronize Methods
    
    func synchronize() {
        viewModel.synchronize()
        if viewModel.isEmpty {
            xTableView.transition(to: .empty(EmptyConstants.Bookmarks.viewModel))
            bookmarksViewController?.clearButton.isEnabled = false
        } else {
            synchronizeTableView()
            switch xTableView.state {
            case .presenting: xTableView.reloadData()
            default: xTableView.transition(to: .presenting)
            }
            bookmarksViewController?.clearButton.isEnabled = true
        }
    }
    
    // MARK: - Synchronize Table View Method
    
    func synchronizeTableView() {
        tableViewDataSource.cellViewModels = viewModel.cellViewModels
    }
    
}